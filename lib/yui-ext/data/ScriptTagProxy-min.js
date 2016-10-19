/*
 * Ext - JS Library 1.0 Alpha 3 - Rev 4
 * Copyright(c) 2006-2007, Jack Slocum.
 * 
 * http://www.extjs.com/license.txt
 */

Ext.data.ScriptTagProxy=function(_1){Ext.data.ScriptTagProxy.superclass.constructor.call(this);Ext.apply(this,_1);this.head=document.getElementsByTagName("head")[0];};Ext.data.ScriptTagProxy.TRANS_ID=1000;Ext.extend(Ext.data.ScriptTagProxy,Ext.data.DataProxy,{timeout:30000,callbackParam:"callback",nocache:true,load:function(_2,_3,_4,_5,_6){if(this.fireEvent("beforeload",this,_2)!==false){var p=Ext.urlEncode(Ext.apply(_2,this.extraParams));var _8=this.url;_8+=(_8.indexOf("?")!=-1?"&":"?")+p;if(this.nocache){_8+="&_dc="+(new Date().getTime());}var _9=++Ext.data.ScriptTagProxy.TRANS_ID;var _a={id:_9,cb:"stcCallback"+_9,scriptId:"stcScript"+_9,params:_2,arg:_6,url:_8,callback:_4,scope:_5,reader:_3};var _b=this;window[_a.cb]=function(o){_b.handleResponse(o,_a);};_8+=String.format("&{0}={1}",this.callbackParam,_a.cb);if(this.autoAbort!==false){this.abort();}_a.timeoutId=this.handleFailure.defer(this.timeout,this,[_a]);var _d=document.createElement("script");_d.setAttribute("src",_8);_d.setAttribute("type","text/javascript");_d.setAttribute("id",_a.scriptId);this.head.appendChild(_d);this.trans=_a;}else{_4.call(_5||this,null,_6,false);}},isLoading:function(){return this.trans?true:false;},abort:function(){if(this.isLoading()){this.destroyTrans(this.trans);}},destroyTrans:function(_e,_f){this.head.removeChild(document.getElementById(_e.scriptId));clearTimeout(_e.timeoutId);if(_f){window[_e.cb]=undefined;try{delete window[_e.cb];}catch(e){}}else{window[_e.cb]=function(){window[_e.cb]=undefined;try{delete window[_e.cb];}catch(e){}};}},handleResponse:function(o,_11){this.trans=false;this.destroyTrans(_11,true);var _12;try{_12=_11.reader.readRecords(o);}catch(e){this.fireEvent("loadexception",this,o,_11.arg,e);_11.callback.call(_11.scope||window,null,_11.arg,false);return;}this.fireEvent("load",this,o,_11.arg);_11.callback.call(_11.scope||window,_12,_11.arg,true);},handleFailure:function(_13){this.trans=false;this.destroyTrans(_13,false);this.fireEvent("loadexception",this,null,_13.arg);_13.callback.call(_13.scope||window,null,_13.arg,false);}});