attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;

varying vec3 vpos;
varying vec3 vnorm;

uniform mat4 ModelView, Projection;

void main()
{
    vpos = vPosition;
    vnorm = vNormal;
    texCoord = vTexCoord;

    gl_Position = Projection * ModelView * vec4(vPosition, 1.0);
}
