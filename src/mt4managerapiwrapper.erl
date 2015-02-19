-module(mt4managerapiwrapper).
-include("../include/managerapiwrapper.hrl").
-export([load_mt4_manager_dll/0, connect/1, error_description/1, trade_transaction/1]).
-export([login/2,disconnect/0,is_connected/0,ping/0]).
%symbols
-export([symbols_refresh/0,symbols_get_all/0]).
%users
-export([users_request_all/0,users_request/1,users_create_new/1]).

% Automatically load native code module
-on_load(start/0).




start() ->
    erlang:load_nif("mt4managerapiwrapper", 0).

trade_transaction(_Mt4_Trans_Info)->
	exit(nif_library_not_loaded).
error_description(_ErrCode)->
	exit(nif_library_not_loaded).
load_mt4_manager_dll()->
	exit(nif_library_not_loaded).
connect(_Mt4Ip)->
	exit(nif_library_not_loaded).
login(_Acc,_Password)->
	exit(nif_library_not_loaded).
disconnect()->
	exit(nif_library_not_loaded).
is_connected()->
	exit(nif_library_not_loaded).
ping()->
	exit(nif_library_not_loaded).
%symbols
symbols_refresh()->
	exit(nif_library_not_loaded).
symbols_get_all()->
	exit(nif_library_not_loaded).
%users
users_request_all()->
	exit(nif_library_not_loaded).
users_request(_ListOfLogins)->
	exit(nif_library_not_loaded).
users_create_new(_Mt4User)->
	exit(nif_library_not_loaded).