/*
 * Ext - JS Library 1.0 Alpha 3 - Rev 4
 * Copyright(c) 2006-2007, Jack Slocum.
 * 
 * http://www.extjs.com/license.txt
 */

(function(){Ext.Layer=function(_1,_2){_1=_1||{};var dh=Ext.DomHelper;var cp=_1.parentEl,_5=cp?Ext.getDom(cp):document.body;if(_2){this.dom=Ext.getDom(_2);}if(!this.dom){var o=_1.dh||{tag:"div",cls:"x-layer"};this.dom=dh.append(_5,o);}if(_1.cls){this.addClass(_1.cls);}this.constrain=_1.constrain!==false;this.visibilityMode=Ext.Element.VISIBILITY;if(_1.id){this.id=this.dom.id=_1.id;}else{this.id=Ext.id(this.dom);}var _7=(_1.zindex||parseInt(this.getStyle("z-index"),10))||11000;this.position("absolute",_7);if(_1.shadow){this.shadowOffset=_1.shadowOffset||4;this.shadow=new Ext.Shadow({offset:this.shadowOffset,mode:_1.shadow});}else{this.shadowOffset=0;}if(_1.shim!==false&&Ext.useShims){this.shim=this.createShim();this.shim.setOpacity(0);this.shim.position("absolute",_7-2);}this.useDisplay=_1.useDisplay;this.hide();};var _8=Ext.Element.prototype;Ext.extend(Ext.Layer,Ext.Element,{sync:function(_9){var sw=this.shadow,sh=this.shim;if(this.isVisible()&&(sw||sh)){var w=this.getWidth(),h=this.getHeight();var l=this.getLeft(true),t=this.getTop(true);if(sw){if(_9&&!sw.isVisible()){sw.show(this);}else{sw.realign(l,t,w,h);}if(sh){if(_9){sh.show();}var a=sw.adjusts,s=sh.dom.style;s.left=(l+a.l)+"px";s.top=(t+a.t)+"px";s.width=(w+a.w)+"px";s.height=(h+a.h)+"px";}}else{if(sh){if(_9){sh.show();}sh.setSize(w,h);sh.setLeftTop(l,t);}}}},hideUnders:function(_12){if(this.shadow){this.shadow.hide();}if(this.shim){this.shim.hide();if(_12){this.shim.setLeftTop(-10000,-10000);}}},constrainXY:function(){if(this.constrain){var vw=Ext.lib.Dom.getViewWidth(),vh=Ext.lib.Dom.getViewHeight();var s=Ext.get(document).getScroll();xy=this.getXY();var x=xy[0],y=xy[1];var w=this.dom.offsetWidth+this.shadowOffset,h=this.dom.offsetHeight+this.shadowOffset;var _1a=false;if((x+w)>vw+s.left){x=vw-w-this.shadowOffset;_1a=true;}if((y+h)>vh+s.top){y=vh-h-this.shadowOffset;_1a=true;}if(x<s.left){x=s.left;_1a=true;}if(y<s.top){y=s.top;_1a=true;}if(_1a){xy=[x,y];this.lastXY=xy;_8.setXY.call(this,xy);this.sync();}}},showAction:function(){if(this.useDisplay===true){this.setDisplayed("");}else{if(this.lastXY){_8.setXY.call(this,this.lastXY);}}},hideAction:function(){if(this.useDisplay===true){this.setDisplayed(false);}else{this.setLeftTop(-10000,-10000);}},setVisible:function(v,a,d,c,e){this.showAction();if(a&&v){var cb=function(){this.sync(true);if(c){c();}}.createDelegate(this);_8.setVisible.call(this,true,true,d,cb,e);}else{if(!v){this.hideUnders(true);}var cb=c;if(a){cb=function(){this.hideAction();if(c){c();}}.createDelegate(this);}_8.setVisible.call(this,v,a,d,cb,e);if(v){this.sync(true);}else{if(!a){this.hideAction();}}}},beforeFx:function(){this.beforeAction();return Ext.Layer.superclass.beforeFx.apply(this,arguments);},afterFx:function(){Ext.Layer.superclass.afterFx.apply(this,arguments);this.sync(this.isVisible());},beforeAction:function(){if(this.shadow){this.shadow.hide();}},setXY:function(xy,a,d,c,e){this.fixDisplay();this.beforeAction();this.lastXY=xy;var cb=this.createCB(c);_8.setXY.call(this,xy,a,d,cb,e);if(!a){cb();}},createCB:function(c){var el=this;return function(){el.constrainXY();el.sync(true);if(c){c();}};},setX:function(x,a,d,c,e){this.setXY([x,this.getY()],a,d,c,e);},setY:function(y,a,d,c,e){this.setXY([this.getX(),y],a,d,c,e);},setSize:function(w,h,a,d,c,e){this.beforeAction();var cb=this.createCB(c);_8.setSize.call(this,w,h,a,d,cb,e);if(!a){cb();}},setWidth:function(w,a,d,c,e){this.beforeAction();var cb=this.createCB(c);_8.setWidth.call(this,w,a,d,cb,e);if(!a){cb();}},setHeight:function(h,a,d,c,e){this.beforeAction();var cb=this.createCB(c);_8.setHeight.call(this,h,a,d,cb,e);if(!a){cb();}},setBounds:function(x,y,w,h,a,d,c,e){this.beforeAction();var cb=this.createCB(c);if(!a){_8.setXY.call(this,[x,y]);_8.setSize.call(this,w,h,a,d,cb,e);cb();}else{_8.setBounds.call(this,x,y,w,h,a,d,cb,e);}return this;},setZIndex:function(_4f){this.setStyle("z-index",_4f+2);if(this.shadow){this.shadow.setZIndex(_4f+1);}if(this.shim){this.shim.setStyle("z-index",_4f);}}});})();