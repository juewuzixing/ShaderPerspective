import QtQuick 2.9

Item {
    id: root
    property alias sourceItem: sourceMask.sourceItem
    property alias w: shader.width
    property alias h: shader.height
    property bool trans: false          // 标志位是否启用变形
    property int lOrR: 0                // 标志位设置左转或右转    0 || 1
    property real rangeX: 0.0           // 水平方向的缩放幅度      0.0 ~ 1.0
    property real rangeY: 0.0           // 竖直方向的缩放幅度      0.0 ~ 1.0
    property real originX: 0.0          // x轴原点               0.0 ~ 1.0
    property real originY: 0.2          // y轴原点               0.0 ~ 1.0

    ShaderEffectSource {
        id: sourceMask
        smooth: true
        hideSource: true
    }
    ShaderEffect {
        id: shader
        property variant source: sourceMask
        mesh: GridMesh { resolution: Qt.size (16, 16) }

        property bool minimized: root.trans                  // 启用变形
        property real minimizeX: root.rangeX                 // 水平方向的缩放幅度     0.0 ~ 1.0
        property real minimizeY: root.rangeY                 // 竖直方向的缩放幅度     0.0 ~ 1.0
        property real sideX: root.originX                    // x轴原点          0.0 ~ 1.0
        property real sideY: root.originY                    // y轴原点          0.0 ~ 1.0
        property int lAndR: root.lOrR                        // 标志位：设置左转或右转    0 || 1

        vertexShader: "
        uniform highp mat4 qt_Matrix;
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;

        uniform highp float minimizeX;
        uniform highp float minimizeY;
        uniform highp float width;
        uniform highp float height;
        uniform highp float sideX;
        uniform highp float sideY;

        uniform lowp int lAndR;

        varying highp vec2 qt_TexCoord0;

        void main() {
            qt_TexCoord0 = qt_MultiTexCoord0;
            highp vec4 pos = qt_Vertex;
            pos.x = mix(qt_Vertex.x, sideX * width, minimizeX);
            highp float x2 = width - pos.x;
            highp float t = (lAndR == 0) ? pos.x / width : x2 / width;
            pos.y = mix(qt_Vertex.y, sideY * height, minimizeY * t);

            gl_Position = qt_Matrix * pos;
        }"

        fragmentShader: "
        varying highp vec2 qt_TexCoord0;
        uniform sampler2D source;
        uniform lowp float qt_Opacity;
        void main() {
            gl_FragColor = texture2D(source, qt_TexCoord0);
        }"
    }
}
