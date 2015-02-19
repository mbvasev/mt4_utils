%%%-------------------------------------------------------------------
%%% @author Martin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. II 2015 14:55 ч.
%%%-------------------------------------------------------------------
-module(mt4_direct_connection).
-author("Martin").

-behaviour(gen_server).
-include("../include/managerapiwrapper.hrl").

%% API
-export([start_link/0, disconect/0, get_account/1, create_balance_operation/3, create_account/11, ping/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(PING_CMD, ping).
-define(CREATE_BALANCE_OP_CMD, create_bal_op).
-define(GET_ACOUNT_CMD, get_balance).
-define(SERVER, ?MODULE).
-define(CREATE_ACCOUNT_CMD,create_account).
-define(DISCONNECT_CMD,disconect).
-record(mt4_connection_settings, {name,mt4host,login,password,managerDll}).
%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

create_account(Name,Address,Email,City,Comment,Id,Phone,Country,Zipcode,Group,Leverage)->
  AcountInfo = #mt4_user{name = Name,address =  Address,email =Email, city = City,comment =  Comment,id =Id,
    phone = Phone,country =  Country,zipcode =  Zipcode,group =  Group,leverage =  Leverage},
  gen_server:call(?SERVER,{?CREATE_ACCOUNT_CMD,AcountInfo}).

get_account(Login)->
  gen_server:call(?SERVER,{?GET_ACOUNT_CMD,Login}).

create_balance_operation(Login,Amount,Comment)->
  gen_server:call(?SERVER,{?CREATE_BALANCE_OP_CMD,Login,Amount,Comment}).

ping()->
  gen_server:call(?SERVER,?PING_CMD).
disconect() ->
  gen_server:cast(?SERVER,?DISCONNECT_CMD).


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, State :: #mt4_connection_settings{}} | {ok, State :: #mt4_connection_settings{}, timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).

init([]) ->
  io:format("inti ~n"),
  ConnSettings = #mt4_connection_settings{name = "Dev Ventsi",login = 10,managerDll = "managerapi64.dll",mt4host = "95.43.216.232:443",password = "Qwerty1"},
  ok = mt4managerapiwrapper:load_mt4_manager_dll(),
  ok = mt4managerapiwrapper:connect(ConnSettings#mt4_connection_settings.mt4host),
  ok = mt4managerapiwrapper:login(ConnSettings#mt4_connection_settings.login,ConnSettings#mt4_connection_settings.password),
  ok = mt4managerapiwrapper:symbols_refresh(),
  {ok,ConnSettings}.
handle_call(?PING_CMD, _From, Mt4_connection_settings) ->
  {reply,mt4managerapiwrapper:ping(),Mt4_connection_settings};

handle_call({?CREATE_BALANCE_OP_CMD,Login,Amount,Comment}, _From, Mt4_connection_settings) ->
  Mt4_trade_trans = #mt4_trade_trans_info{type = ?TT_BR_BALANCE, cmd = ?OP_BALANCE,comment = Comment,orderby = Login,price = Amount},
  case catch(mt4managerapiwrapper:trade_transaction(Mt4_trade_trans)) of
    {ok,Ticket} ->
      {reply,{ok,Ticket},Mt4_connection_settings};
    {error,ErrCode}->
      {reply,{error,mt4managerapiwrapper:error_description(ErrCode)},Mt4_connection_settings}
  end;


handle_call({?GET_ACOUNT_CMD,Login}, _From, Mt4_connection_settings) ->
  case catch(mt4managerapiwrapper:users_request([Login])) of
    {ok,Users} when length(Users)=:=1->
      {reply,{ok,hd(Users)},Mt4_connection_settings};
    {ok,Users} when length(Users)=:=0->
      {reply,not_found,Mt4_connection_settings};
    {error,ErrCode}->
      {reply,{error,mt4managerapiwrapper:error_description(ErrCode)},Mt4_connection_settings};
    {badarg,Index}->
      {reply,{error,{badarg,Index},Mt4_connection_settings}}
  end;

handle_call({?CREATE_ACCOUNT_CMD,AccountInfo}, _From, Mt4_connection_settings) ->
    case catch(mt4managerapiwrapper:users_create_new(AccountInfo)) of
      {ok,Login} ->
        {reply,{ok,Login},Mt4_connection_settings};
      {error,ErrCode}->
        {reply,{error,mt4managerapiwrapper:error_description(ErrCode)},Mt4_connection_settings}
    end.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #mt4_connection_settings{}) ->
  {noreply, NewState :: #mt4_connection_settings{}} |
  {noreply, NewState :: #mt4_connection_settings{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #mt4_connection_settings{}}).
handle_cast(?DISCONNECT_CMD,State)->
  mt4managerapiwrapper:disconnect(),
  {noreply,State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #mt4_connection_settings{}) ->
  {noreply, NewState :: #mt4_connection_settings{}} |
  {noreply, NewState :: #mt4_connection_settings{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #mt4_connection_settings{}}).
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #mt4_connection_settings{}) -> term()).
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #mt4_connection_settings{},
    Extra :: term()) ->
  {ok, NewState :: #mt4_connection_settings{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
