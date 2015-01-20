part of PIXI;

class AlphaMaskFilter extends AbstractFilter {
  Texture texture;

  AlphaMaskFilter(this.texture) {
    texture.baseTexture._powerOf2 = true;
    this.uniforms = {
        'mask': {
            'type': 'sampler2D', 'value':texture
        },
        'mapDimensions': {
            'type': '2f', 'value':{
                'x':1, 'y':5112
            }
        },
        'dimensions': {
            'type': '4fv', 'value':[0, 0, 0, 0]
        }
    };

    if (texture.baseTexture.hasLoaded) {
      this.uniforms['mask']['value']['x'] = texture.width;
      this.uniforms['mask']['value']['y'] = texture.height;
    }
    else {
      //this.boundLoadedFunction = this.onTextureLoaded.bind(this);

      texture.baseTexture.addEventListener('loaded', this.onTextureLoaded);
    }

    this.fragmentSrc = [
        'precision mediump float;',
        'varying vec2 vTextureCoord;',
        'varying vec4 vColor;',
        'uniform sampler2D mask;',
        'uniform sampler2D uSampler;',
        'uniform vec2 offset;',
        'uniform vec4 dimensions;',
        'uniform vec2 mapDimensions;',

        'void main(void) {',
        '   vec2 mapCords = vTextureCoord.xy;',
        '   mapCords += (dimensions.zw + offset)/ dimensions.xy ;',
        '   mapCords.y *= -1.0;',
        '   mapCords.y += 1.0;',
        '   mapCords *= dimensions.xy / mapDimensions;',

        '   vec4 original =  texture2D(uSampler, vTextureCoord);',
        '   float maskAlpha =  texture2D(mask, mapCords).r;',
        '   original *= maskAlpha;',
        //'   original.rgb *= maskAlpha;',
        '   gl_FragColor =  original;',
        //'   gl_FragColor = gl_FragColor;',
        '}'
    ];

  }

  onTextureLoaded(e) {
    this.uniforms['mapDimensions']['value']['x'] = this.uniforms['mask']['value'].width;
    this.uniforms['mapDimensions']['value']['y'] = this.uniforms['mask']['value'].height;

    (this.uniforms['mask']['value'].baseTexture as BaseTexture).removeEventListener('loaded', this.onTextureLoaded);
  }

  Texture get map {
    return this.uniforms['mask']['value'];
  }

  set map(Texture value) {
    this.uniforms['mask']['value'] = value;
  }

}
