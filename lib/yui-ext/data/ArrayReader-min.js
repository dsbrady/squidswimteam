/*
 * Ext - JS Library 1.0 Alpha 3 - Rev 4
 * Copyright(c) 2006-2007, Jack Slocum.
 * 
 * http://www.extjs.com/license.txt
 */

Ext.data.ArrayReader=function(_1,_2){Ext.data.ArrayReader.superclass.constructor.call(this,_1,_2);};Ext.extend(Ext.data.ArrayReader,Ext.data.JsonReader,{readRecords:function(o){var _4=this.meta?this.meta.id:null;var _5=this.recordType,_6=_5.prototype.fields;var _7=[];var _8=o;for(var i=0;i<_8.length;i++){var n=_8[i];var _b={};var id=((_4||_4===0)&&n[_4]!==undefined&&n[_4]!==""?n[_4]:null);for(var j=0,_e=_6.length;j<_e;j++){var f=_6.items[j];var k=f.mapping||j;var v=n[k]!==undefined?n[k]:f.defaultValue;v=f.convert(v);_b[f.name]=v;}var _12=new _5(_b,id);_12.json=n;_7[_7.length]=_12;}return {records:_7,totalRecords:_7.length};}});
