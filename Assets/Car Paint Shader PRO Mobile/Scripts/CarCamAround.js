
#pragma strict

var target : Transform;

private var distance = 5.0;
private var heightDamping = 2.0;
private var rotationDamping = 3.0;
private var lastPos = Vector3.zero;
private var currentVelocity = Vector3.zero;
private var wantedRotationAngle = 0.0;

var rot : float;

function LateUpdate () {

	if (!target) return;
	
	var updatedVelocity = (target.position - lastPos) / Time.deltaTime;
	updatedVelocity.y = 0.0;
	
	lastPos = target.position;
	
	rot += Time.deltaTime;
	wantedRotationAngle = -45 - rot * 30;

	var wantedHeight = 1.25;

	var currentRotationAngle = transform.eulerAngles.y;
	var currentHeight = transform.position.y;

	currentRotationAngle = wantedRotationAngle;//Mathf.LerpAngle (currentRotationAngle, wantedRotationAngle, rotationDamping * Time.deltaTime);

	currentHeight = Mathf.Lerp (currentHeight, wantedHeight, heightDamping * Time.deltaTime);

	var currentRotation = Quaternion.Euler (0, currentRotationAngle, 0);
	
	var wantedposition = target.position;
	wantedposition -= currentRotation * Vector3.forward * distance;

	wantedposition.y = currentHeight;
	
	transform.position = Vector3.Lerp(transform.position, wantedposition, Time.deltaTime * 10);	

	var look = target.position;
	look.y = 0.0;

	transform.LookAt (look);


}














