﻿
function jsOnload() {
    //var view: egret3d.Class_Mesh = new egret3d.Class_Mesh();
    var view: egret3d.Class_SkinAnimation = new egret3d.Class_SkinAnimation();

}

window.onload = () => {

    egret3d.Egret3DEngine.preload(() => jsOnload());
}
