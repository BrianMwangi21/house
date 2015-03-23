var renderer = null,
    scene = null,
    camera = null,
    cubeGroup = null,
    cube = null,
    sphereGroup = null,
    sphere = null,
    cone = null,
    uniforms = null,
    duration = 5000,
    currentTime = Date.now(),
    mouseDown = false,
    pageX = 0;

function animate() {

    var now = Date.now();
    var deltat = now - currentTime;
    currentTime = now;
    var fract = deltat / duration;
    var angle = Math.PI * 2 * fract;

    // Rotate the cube about its Y axis
    cube.rotation.y += angle;

    // Rotate the sphere group about its Y axis
    sphereGroup.rotation.y -= angle / 2;

    // Rotate the cone about its X axis (tumble forward)
    cone.rotation.x += angle;

    uniforms.time.value += fract;
}
function run() {
    requestAnimationFrame(function () {
        run();
    });

    // Render the scene
    renderer.render(scene, camera);

    // Spin the cube for next frame
    animate();

}
function createScene(canvas) {

    // Create the Three.js renderer and attach it to our canvas
    renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true });

    // Set the viewport size
    renderer.setSize(canvas.width, canvas.height);

    // Create a new Three.js scene
    scene = new THREE.Scene();

    // Add  a camera so we can view the scene
    camera = new THREE.PerspectiveCamera(45, canvas.width / canvas.height, 1, 4000);
    camera.position.z = 10;
    scene.add(camera);

    // Add a directional light to show off the object
    var light = new THREE.DirectionalLight(0xffffff, 1.5);

    // Position the light out from the scene, pointing at the origin
    light.position.set(.5, .2, 1);
    scene.add(light);

    cubeGroup = new THREE.Object3D;

    var GLOWMAP = THREE.ImageUtils.loadTexture("resources/images/aah.jpg");
    var NOISEMAP = THREE.ImageUtils.loadTexture("resources/images/noisy.png");
    uniforms = {

        time: { type: "f", value: 1.0 },
        texture1: { type: "t", value: NOISEMAP },
        texture2: { type: "t", value: GLOWMAP }

    };

    uniforms.texture1.value.wrapS = uniforms.texture1.value.wrapT = THREE.RepeatWrapping;
    uniforms.texture2.value.wrapS = uniforms.texture2.value.wrapT = THREE.RepeatWrapping;

    var material = new THREE.ShaderMaterial({

        uniforms: uniforms,
        vertexShader: document.getElementById('vertexShader').textContent,
        fragmentShader: document.getElementById('fragmentShader').textContent,
        transparent: true,
    });

    // Create the cube geometry
    var geometry = new THREE.CubeGeometry(2, 2, 2);

    // And put the geometry and material together into a mesh
    cube = new THREE.Mesh(geometry, material);

    // Tilt the mesh toward the viewer
    cube.rotation.x = Math.PI / 5;
    cube.rotation.y = Math.PI / 5;

    // Add the cube mesh to our group
    cubeGroup.add(cube);

    // Create a group for the sphere
    sphereGroup = new THREE.Object3D;
    cubeGroup.add(sphereGroup);

    // Move the sphere group up and back from the cube
    sphereGroup.position.set(0, 3, -4);

    // Create the sphere geometry
    geometry = new THREE.SphereGeometry(1, 20, 20);

    // And put the geometry and material together into a mesh
    sphere = new THREE.Mesh(geometry, material);

    // Add the sphere mesh to our group
    sphereGroup.add(sphere);

    // Create the cone geometry
    geometry = new THREE.CylinderGeometry(0, .333, .444, 20, 5);

    // And put the geometry and material together into a mesh
    cone = new THREE.Mesh(geometry, material);

    // Move the cone up and out from the sphere
    cone.position.set(1, 1, -.667);

    // Add the cone mesh to our group
    sphereGroup.add(cone);

    // Now add the group to our scene
    scene.add(cubeGroup);
}
function rotateScene(deltax) {
    cubeGroup.rotation.y += deltax / 100;
    $("#rotation").html("rotation: 0," + cubeGroup.rotation.y.toFixed(2) + ",0");
}
function scaleScene(scale) {
    cubeGroup.scale.set(scale, scale, scale);
    $("#scale").html("scale: " + scale);
}
function onMouseMove(evt) {
    if (!mouseDown)
        return;

    evt.preventDefault();

    var deltax = evt.pageX - pageX;
    pageX = evt.pageX;
    rotateScene(deltax);
}
function onMouseDown(evt) {
    evt.preventDefault();

    mouseDown = true;
    pageX = evt.pageX;
}
function onMouseUp(evt) {
    evt.preventDefault();

    mouseDown = false;

    cubeGroup.visible = false;
}
function addMouseHandler(canvas) {
    canvas.addEventListener('mousemove',
        function (e) {
            onMouseMove(e);
        }, false);
    canvas.addEventListener('mousedown',
        function (e) {
            onMouseDown(e);
        }, false);
    canvas.addEventListener('mouseup',
        function (e) {
            onMouseUp(e);
        }, false);
}
$(document).ready(
    function () {

        $("#slider").slider({min: 0, max: 2, value: 1, step: 0.01, animate: false});
        $("#slider").on("slide", function (e, u) {
            console.log(u.value);
            scaleScene(u.value);
        });

        var canvas = document.getElementById("webglcanvas");

        // create the scene
        createScene(canvas);

        // add mouse handling so we can rotate the scene
        addMouseHandler(canvas);

        // Run the run loop
        run();
    }
);