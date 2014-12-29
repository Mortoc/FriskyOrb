#pragma strict
var flipDirection : boolean = false;
var speed : float;
private var timer : float;

function Update () {

	timer += flipDirection ?  Time.deltaTime * -speed : Time.deltaTime * speed;
	
	//This is how we pass timer param into shader
	GetComponent.<Renderer>().material.SetFloat("_EnvTimer",timer);

}