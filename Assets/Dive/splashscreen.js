#pragma strict

var splashTexture : Texture;

var fadeTime = 1.0;
var fadeAmount = 0.0f;
var nextscene= "demoscene";

enum Fade {In, Out}


function Start () {
    yield WaitForSeconds(0.25);

    yield FadeGUITexture(fadeTime, Fade.In);

    yield WaitForSeconds(0.5);

    yield FadeGUITexture(fadeTime, Fade.Out);
	
	yield WaitForSeconds(0.25);
    
    Application.LoadLevel(nextscene);
}


function OnGUI() {
	GUI.color = new Color(1.0f, 1.0f, 1.0f, fadeAmount);
	
	var textureWidth:float = splashTexture.width;
	var textureHeight:float = splashTexture.height;
	var aspect:float = textureHeight / textureWidth;
	var width:float = Screen.width * 0.66f;
	var height:float = width * aspect;
	
	GUI.DrawTexture(new Rect(
		(Screen.width - width) / 2,
		(Screen.height - height) / 2,
		width, height
	), splashTexture);
}

 

function FadeGUITexture (timer : float, fadeType : Fade) {
    var start = fadeType == Fade.In? 0.0 : 1.0;
    var end = fadeType == Fade.In? 1.0 : 0.0;
    var i = 0.0;
    var step = 1.0/timer;

    while (i < 1.0) {
        i += step * Time.deltaTime;
        fadeAmount = Mathf.Lerp(start, end, i)*.5;
        yield;
    }
}

