part of PIXI;


class ComplexPrimitiveShader extends Shader  {
  RenderingContext gl;
  Program program;
  List<String> fragmentSrc;
  List<String> vertexSrc;

  List attributes;

  var uniforms;

  ComplexPrimitiveShader (this.gl) {
    _UID = _UID++;

    program = null;


    /**
     * @property fragmentSrc
     * @type Array
     */
    fragmentSrc = [
        'precision mediump float;',





        'varying vec4 vColor;',


        'void main(void) {',
        '   gl_FragColor = vColor;',
        '}'
    ];


    /**
     * @property vertexSrc
     * @type Array
     */
    vertexSrc  = [
        'attribute vec2 aVertexPosition;',
        //'attribute vec4 aColor;',
        'uniform mat3 translationMatrix;',
        'uniform vec2 projectionVector;',
        'uniform vec2 offsetVector;',

        'uniform vec3 tint;',
        'uniform float alpha;',
        'uniform vec3 color;',


        'varying vec4 vColor;',


        'void main(void) {',
        '   vec3 v = translationMatrix * vec3(aVertexPosition , 1.0);',
        '   v -= offsetVector.xyx;',
        '   gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);',
        '   vColor = vec4(color * alpha * tint, alpha);',//" * vec4(tint * alpha, alpha);',
        '}'
    ];


    this.init();

  }


  init()
  {
    //if(gl == null) return;
    var program = compileProgram(gl, this.vertexSrc, this.fragmentSrc);
    gl.useProgram(program);


    // get and store the uniforms for the shader
    this.projectionVector = gl.getUniformLocation(program, 'projectionVector');
    this.offsetVector = gl.getUniformLocation(program, 'offsetVector');
    this.tintColor = gl.getUniformLocation(program, 'tint');
    this.color = gl.getUniformLocation(program, 'color');




    // get and store the attributes
    this.aVertexPosition = gl.getAttribLocation(program, 'aVertexPosition');
    // this.colorAttribute = gl.getAttribLocation(program, 'aColor');


    this.attributes = [this.aVertexPosition, this.colorAttribute];


    this.translationMatrix = gl.getUniformLocation(program, 'translationMatrix');
    this.alpha = gl.getUniformLocation(program, 'alpha');


    this.program = program;
  }


  /**
   * Destroys the shader
   * @method destroy
   *
   */
  destroy()
  {
    this.gl.deleteProgram( this.program );
    this.uniforms = null;
    this.gl = null;


    this.attributes = null;
  }

}
