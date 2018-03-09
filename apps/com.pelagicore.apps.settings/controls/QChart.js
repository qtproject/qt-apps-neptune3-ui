// Copyright (c) 2013 Nick Downie

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

var Chart = function(canvas, context) {
    var chart = this;

    this.Doughnut = function(data,options) {
        chart.Doughnut.defaults = {
            segmentShowStroke: true,
            segmentStrokeColor: "#fff",
            segmentStrokeWidth: 2,
            percentageInnerCutout: 50
        };

        var config = (options) ? mergeChartConfig(chart.Doughnut.defaults, options) : chart.Doughnut.defaults;

        return new Doughnut(data, config, context);
    };

    var Doughnut = function(data,config,ctx) {
        var segmentTotal = 0;
        var doughnutRadius = Min([height/2,width/2]) - 5;
        var cutoutRadius = doughnutRadius * (config.percentageInnerCutout/100);

        // /////////////////////////////////////////////////////////////////
        // initialization
        // /////////////////////////////////////////////////////////////////

        this.init = function () {
            for (var i=0; i<data.length; i++) {
                segmentTotal += data[i].value;
            }
        }

        // /////////////////////////////////////////////////////////////////
        // drawing
        // /////////////////////////////////////////////////////////////////

        this.draw = function () {
            clear(ctx);
            drawDoughnutSegments();
        }

        function drawDoughnutSegments () {
            var cumulativeAngle = -Math.PI/2;

            for (var i=0; i<data.length; i++) {
                var segmentAngle = (data[i].value/segmentTotal) * (Math.PI*2);
                var selected = data[i].selected;
                var selectedOuterScale = selected ? 1 : .9;
                var selectedInnerScale = selected ? .9 : 1;
                ctx.beginPath();
                ctx.arc(width/2,height/2,doughnutRadius * selectedOuterScale, cumulativeAngle,cumulativeAngle + segmentAngle,false);
                ctx.arc(width/2,height/2,cutoutRadius * selectedInnerScale, cumulativeAngle + segmentAngle,cumulativeAngle,true);
                ctx.closePath();
                ctx.fillStyle = data[i].color;
                ctx.fill();

                if (config.segmentShowStroke) {
                    ctx.save();
                    ctx.lineWidth = config.segmentStrokeWidth;
                    ctx.globalCompositeOperation = "destination-in";
                    ctx.strokeStyle = "transparent";
                    ctx.stroke();
                    ctx.restore();
                }

// TODO drop shadow... doesn't seem to quite work with QML/Canvas
//                if (selected) {
//                    ctx.save();
//                    //ctx.strokeStyle = data[i].value;
//                    ctx.globalCompositeOperation = "destination-out";
//                    ctx.shadowOffsetX = 15;
//                    ctx.shadowOffsetY = 15;
//                    ctx.shadowColor = Qt.rgba(1, 1, 1, 0.2);
//                    ctx.shadowBlur = 3;
//                    ctx.stroke();
//                    ctx.restore();
//                }

                cumulativeAngle += segmentAngle;
            }
        }
    }

    // /////////////////////////////////////////////////////////////////
    // Helper functions
    // /////////////////////////////////////////////////////////////////

    var clear = function(c) {
        c.clearRect(0, 0, width, height);
    };


    function Max(array) {
        return Math.max.apply(Math, array);
    };

    function Min(array) {
        return Math.min.apply(Math, array);
    };

    function mergeChartConfig(defaults,userDefined) {
        var returnObj = {};
        for (var attrname in defaults) { returnObj[attrname] = defaults[attrname]; }
        for (var attrname in userDefined) { returnObj[attrname] = userDefined[attrname]; }
        return returnObj;
    }
}
