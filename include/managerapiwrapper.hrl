%%%-------------------------------------------------------------------
%%% @author Martin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. II 2015 22:52 ч.
%%%-------------------------------------------------------------------
-author("Martin").
-record(mt4_symbol,{symbol,currency,digits}).
-record(mt4_user,{login=0,name="name",address="address",email="email@email.com",city="city",comment="comment",id="id",phone="08976252",country="United Kingdom",zipcode="zipcode",group="GMART-USD2P",leverage=100,balance=0}).
-record(mt4_trade_trans_info,{type=0,cmd=0,order=0,orderby=0,symbol="",volume=0,price=0.00,sl=0.00,tp=0.00,ie_deviation=0,comment="",expiration=0}).
-define(RET_OK,0).
-define(RET_OK_NONE,1).
-define(RET_ERROR,2).
-define(RET_INVALID_DATA,3).
-define(RET_TECH_PROBLEM,4).
-define(RET_OLD_VERSION,5).
-define(RET_NO_CONNECT,6).
-define(RET_NOT_ENOUGH_RIGHTS,7).
-define(RET_TOO_FREQUENT,8).
-define(RET_MALFUNCTION,9).
-define(RET_GENERATE_KEY,10).
-define(RET_SECURITY_SESSION,11).
%//--- account status
-define(RET_ACCOUNT_DISABLED,64).
-define(RET_BAD_ACCOUNT_INFO,65).
-define(RET_PUBLIC_KEY_MISSING,66).
%--- trade
-define(RET_TRADE_TIMEOUT,128).
-define(RET_TRADE_BAD_PRICES,129).
-define(RET_TRADE_BAD_STOPS,130).
-define(RET_TRADE_BAD_VOLUME,131).
-define(RET_TRADE_MARKET_CLOSED,132).
-define(RET_TRADE_DISABLE,133).
-define(RET_TRADE_NO_MONEY,134).
-define(RET_TRADE_PRICE_CHANGED,135).
-define(RET_TRADE_OFFQUOTES,136).
-define(RET_TRADE_BROKER_BUSY,137).
-define(RET_TRADE_REQUOTE,138).
-define(RET_TRADE_ORDER_LOCKED,139).
-define(RET_TRADE_LONG_ONLY,140).
-define(RET_TRADE_TOO_MANY_REQ,141).
%--- order status notification
-define(RET_TRADE_ACCEPTED,142).
-define(RET_TRADE_PROCESS,143).
-define(RET_TRADE_USER_CANCEL,144).
%--- additional return codes
-define(RET_TRADE_MODIFY_DENIED,145).
-define(RET_TRADE_CONTEXT_BUSY,146).
-define(RET_TRADE_EXPIRATION_DENIED,147).
-define(RET_TRADE_TOO_MANY_ORDERS,148).
-define(RET_TRADE_HEDGE_PROHIBITED,149).
-define(RET_TRADE_PROHIBITED_BY_FIFO,150).

-define(TT_PRICES_GET,0).
-define(TT_PRICES_REQUOTE,1).
%% //--- client trade transaction
-define(TT_ORDER_IE_OPEN,64).
-define(TT_ORDER_REQ_OPEN,65).
-define(TT_ORDER_MK_OPEN,66).
-define(TT_ORDER_PENDING_OPEN,67).
%% //---
-define(TT_ORDER_IE_CLOSE,68).
-define(TT_ORDER_REQ_CLOSE,69).
-define(TT_ORDER_MK_CLOSE,70).
%% //---
-define(TT_ORDER_MODIFY,71).
-define(TT_ORDER_DELETE,72).
-define(TT_ORDER_CLOSE_BY,73).
-define(TT_ORDER_CLOSE_ALL,74).
%% //--- broker trade transactions
-define(TT_BR_ORDER_OPEN,75).
-define(TT_BR_ORDER_CLOSE,76).
-define(TT_BR_ORDER_DELETE,77).
-define(TT_BR_ORDER_CLOSE_BY,78).
-define(TT_BR_ORDER_CLOSE_ALL,79).
-define(TT_BR_ORDER_MODIFY,80).
-define(TT_BR_ORDER_ACTIVATE,81).
-define(TT_BR_ORDER_COMMENT,82).
-define(TT_BR_BALANCE,83).

-define(OP_BUY,0).
-define(OP_SELL,1).
-define(OP_BUY_LIMIT,2).
-define(OP_SELL_LIMIT,3).
-define(OP_BUY_STOP,4).
-define(OP_SELL_STOP,5).
-define(OP_BALANCE,6).
-define(OP_CREDIT,7).