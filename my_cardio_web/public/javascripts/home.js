var nurseId;
var patientId;
var chart;
var chartexists = false;
var measure_type = "Heart Rate";
var measure_type2;
var measure_unit = "bpm";
var measure_unit2;
var chartmode = "Visualize";
var device_type = "Steel HR";

window.onload = async function() {
    try {
        nurseId = sessionStorage.getItem("nurseId");
        let nurse = await $.ajax({
            url: `/api/nurses/${nurseId}`,
            method: "get",
            dataType: "json"
        });

        document.getElementById("nursename").innerHTML = nurse.nurse_name+"'s patients"; 

        let patients = await $.ajax({
            url: `/api/nurses/${nurseId}/patients`,
            method: "get",
            dataType: "json"
        });

        let patienthtml = [];

        for (let patient of patients) {
            patienthtml +=
            '<li class="person">'+
              '<href="" onclick="patientSelected('+patient.codigo+')" class="d-flex align-items-center">'+
                '<img src="images/flutteravatar.png" alt="Image" class="img-fluid mr-3">'+
                '<span class="user-name">'+patient.codigo+'</span>'+
              '</a>'+
            '</li>';

          document.getElementById("patients").innerHTML = patienthtml; 
        }

        //DEFAULT RADIO BUTTON 
        document.getElementById("heartrate").checked = true;
        document.getElementById("visualize").checked = true;

        document.getElementById("visualize").onchange = function () {
            chartmode = "Visualize";
        };

        document.getElementById("insert").onchange = function () {
            chartmode = "Insert";
        };

        document.getElementById("edit").onchange = function () {
            chartmode = "Edit";
        };

        document.getElementById("heartrate").onchange = function () {
            measure_type = "Heart Rate";
            measure_unit = "bpm";
            device_type = "Steel HR";
            getChartData(patientId);
        };
        document.getElementById("bloodpressure").onchange = function () {
            measure_type = "Diastolic Blood Pressure";
            measure_type2 = "Systolic Blood Pressure";
            measure_unit = "mmHg";
            measure_unit2 = "mmHg";
            device_type = "BPM+";
            getChartData(patientId);
        };
        document.getElementById("weight").onchange = function () {
            measure_type = "Weight";
            measure_type2 = "Fat Ratio";
            measure_unit = "kg";
            measure_unit2 = "%";
            device_type = "Body+";
            getChartData(patientId);
        };
        document.getElementById("steps").onchange = function () {
            measure_type = "Steps";
            measure_unit = "#";
            device_type = "Steel HR";
            getChartData(patientId);
        };


    } catch (err) {
    console.log(err);
    }
}

function patientSelected(codigo) {
    document.getElementById("radiobuttons").style.visibility ="visible";
    document.getElementById("userchartinfo").style.visibility ="visible";
    patientId = codigo;
    document.getElementById("chartinfousername").innerHTML = patientId;
    getChartData(patientId);
}

async function getChartData(patientId) {
    let data = [];
    let measureid = [];
    let flags = [];
    let flagid = [];

    if(chartexists) {
        chart.destroy();
    }
    
    let measures = await $.ajax({
        url: `/api/patients/${patientId}/measure/${measure_type}`,
        method: "get",
        dataType: "json"
    });

    let measuresflags = await $.ajax({
        url: `/api/patients/${patientId}/measure/${measure_type}/flags`,
        method: "get",
        dataType: "json"
    });

    if(isIterable(measures)) {
    for (let measure of measures) {
        data.push({x: new Date(measure.instante).getTime(), y: Number(measure.valor)});
        measureid.push(measure.medidaid);
    }
    console.log(data);
    }

    if(isIterable(measuresflags)) {
    for (let measureflag of measuresflags) {
        flags.push({x: new Date(measureflag.instant).getTime(), title: measureflag.measure_flag_title, text:measureflag.measure_flag_text});
        flagid.push(measureflag.measure_flag_id);
    }
    console.log(flags);
    } 

    if(document.getElementById("bloodpressure").checked || document.getElementById("weight").checked) {
        let data2 = [];
        let measureid2 = [];
        let flags2 = [];
        let flagid2 = [];

        let measures_second = await $.ajax({
            url: `/api/patients/${patientId}/measure/${measure_type2}`,
            method: "get",
            dataType: "json"
        });

        let measuresflags_second = await $.ajax({
            url: `/api/patients/${patientId}/measure/${measure_type2}/flags`,
            method: "get",
            dataType: "json"
        });

        if(isIterable(measures_second)) {
        for (let measure2 of measures_second) {
            data2.push({x: new Date(measure2.instante).getTime(), y: Number(measure2.valor)});
            measureid2.push(measure2.medidaid);
        }
        console.log(data2);
        }
    
        if(isIterable(measuresflags_second)) {
        for (let measureflag2 of measuresflags_second) {
            flags2.push({x: new Date(measureflag2.instant).getTime(), title: measureflag2.measure_flag_title, text:measureflag2.measure_flag_text});
            flagid2.push(measureflag2.measure_flag_id);
        }
        console.log(flags2);
        } 

        drawMultipleChart(data,measureid,flags,data2,measureid2,flags2,flagid,flagid2);

    } else {
        drawChart(data,measureid,flags,flagid);
    }
    document.getElementById("chartinfodata").innerHTML = data.length;
    document.getElementById("chartinfodevice").innerHTML = device_type;
}

async function drawChart(data,measureid,flags,flagid) {
    if(data.length >= 1) {
    chart = Highcharts.stockChart('container', {
        rangeSelector: {
            selected: 1
        },
        credits: {
            enabled: false
          },
        yAxis: {
            title: {
                text: measure_type +" ("+measure_unit+")"
            }
        },
        series: [{
            id: "first_series",
            turboThreshold: 0,
            name: measure_type,
            data: data,
            tooltip: {
                valueDecimals: 2,
                valueSuffix: measure_unit,
            },
            events: {
                click: async function(event) {
                    let chartseries = this.chart.series[1];
                    if(chartmode == "Insert") {
                        addFlag(event,chartseries,data,measureid,flags);
                    }
                    if(chartmode == "Edit") {
                        editFlag(event,flags,flagid);
                    }
                }
            }
        },
            {
            type: 'flags',
            accessibility: {
                exposeAsGroupOnly: true,
                description: 'Flagged events.'
            },
            data: flags,
            className: 'main-color',
            onSeries: 'first_series',
            shape: 'circlepin',
            width: 16
        }]
    });
    chartexists = true;
    } else {
        drawEmptyChart();
    }
}

async function drawMultipleChart(data,measureid,flags,data2,measureid2,flags2,flagid,flagid2) {
    if(data.length >= 1 || data2.length >= 1) {
    chart = Highcharts.stockChart('container', {
        rangeSelector: {
            selected: 1
        },
        credits: {
            enabled: false
        },
        yAxis: [{
            title: {
                text: measure_type +" ("+measure_unit+") "+"/ "+measure_type2 +" ("+measure_unit2+")"
            },
          },
        ],
        plotOptions: {
            series: {
                showInNavigator: true
            }
        },
        series: [{
            id: "first_series",
            turboThreshold: 0,
            name: measure_type,
            data: data,
            tooltip: {
                valueDecimals: 2,
                valueSuffix: measure_unit,
            },
            events: {
                click: async function(event) {
                    let chartseries = this.chart.series[1];
                    if(chartmode == "Insert") {
                        addFlag(event,chartseries,data,measureid,flags);
                    }
                    if(chartmode == "Edit") {
                        editFlag(event,flags,flagid);
                    }
                }
            }
          },
          {
            type: 'flags',
            accessibility: {
                exposeAsGroupOnly: true,
                description: 'Flagged events.'
            },
            data: flags,
            onSeries: 'first_series',
            shape: 'squarepin',
            width: 16
        },
          {
            id: "second_series",
            turboThreshold: 0,
            name: measure_type2,
            data: data2,
            tooltip: {
                valueDecimals: 2,
                valueSuffix: measure_unit2,
            },
            events: {
                click: async function(event) {
                    let chartseries = this.chart.series[1];
                    if(chartmode == "Insert") {
                        addFlag(event,chartseries,data2,measureid2,flags2);
                    }
                    if(chartmode == "Edit") {
                        editFlag(event,flags2,flagid2);
                    }
                }
            }
          },
          {
            type: 'flags',
            accessibility: {
                exposeAsGroupOnly: true,
                description: 'Flagged events.'
            },
            data: flags2,
            onSeries: 'second_series',
            shape: 'circlepin',
            width: 16
        },
        ]
    });

    chartexists = true;

} else {
    drawEmptyChart();
}
}

function isIterable(obj) {
    // checks for null and undefined
    if (obj == null) {
      return false;
    }
    return typeof obj[Symbol.iterator] === 'function';
}

async function addFlag(event,chartseries,data,measureid,flags) {

    let measure_id;
    let flag_exists = false;
    let time = new Date(event.point.x).getTime();
    let addModal = new bootstrap.Modal(document.getElementById('addModal'));
    let xExtremes = chart.xAxis[0].getExtremes();
    let yExtremes = chart.yAxis[0].getExtremes();
    let delayInMilliseconds = 1000; //1 second

    console.log(flags);
    console.log(flags.length);

    for(let j = 0; j < flags.length; j++) {
        if(time === flags[j].x) {
            flag_exists = true;
            break;
        } else {
            flag_exists = false;
        }
    }
    
    for (let i = 0; i < data.length; i++) {
        if(time === data[i].x && flag_exists == false) {
            measure_id = measureid[i];
            addModal.show();
        }
    }

    let title = document.getElementById("flagtitle");
    let text = document.getElementById("flagtext");
    title.value = "";
    text.value = "";

    document.getElementById("createflag").onclick = async function() {

        let obj = {
            measure_id: measure_id,
            measure_title: title.value,
            measure_text: text.value
        }

        let newFlag = await $.ajax({
            url: '/api/nurses/addflag',
            method: 'post',
            data: JSON.stringify(obj),
            contentType: 'application/json',
            error: function() {
                alert(arguments[0].responseJSON.err); 
            },
            success: function(){  
                chartseries.addPoint({ 
                    title: title, 
                    x: event.point.x,
                    text: text
                });
                addModal.hide();
                getChartData(patientId);
                setTimeout(function() {
                    chart.xAxis[0].setExtremes(xExtremes.userMin,xExtremes.userMax, true, true);
                    chart.yAxis[0].setExtremes(yExtremes.min, yExtremes.max, true, true);
                }, delayInMilliseconds);
            }
        });
    }

}

async function drawEmptyChart() {
    
    chart = Highcharts.chart('container', {
        title: {
            text: '',
        },
        credits: {
            enabled: false
          },
        series: []
    
    }, function(chart) { // on complete
     
        chart.renderer.text('No data available', 650, 330)
            .css({
                color: '#023436',
                fontSize: '16px'
            })
            .add();
        
    });
    chartexists = true;
}

async function editFlag(event,flags,flagid) {

    let flag_id;
    let flag_info;
    let time = new Date(event.point.x).getTime();
    let editModal = new bootstrap.Modal(document.getElementById('editModal'));
    let xExtremes = chart.xAxis[0].getExtremes();
    let yExtremes = chart.yAxis[0].getExtremes();
    let delayInMilliseconds = 1000; //1 second

    for (let i = 0; i < flags.length; i++) {
        if(time === flags[i].x) {
            flag_id = flagid[i];
            flag_info = flags[i];
            editModal.show();
        }
    }

    let title = document.getElementById("editflagtitle");
    let text = document.getElementById("editflagtext");
    title.value = flag_info.title;
    text.value = flag_info.text;

    document.getElementById("editflag").onclick = async function() {

        let obj = {
            measure_flag_title: title.value,
            measure_flag_text: text.value,
            measure_flag_id: flag_id
        }
        console.log(obj);
        
        let editFlag = await $.ajax({
            url: `/api/nurses/editflag`,
            method: 'put',
            data: JSON.stringify(obj),
            contentType: 'application/json',
            error: function() {
                alert(arguments[0].responseJSON.err); 
            },
            success: function(){  
                editModal.hide();
                getChartData(patientId);
                setTimeout(function() {
                    chart.xAxis[0].setExtremes(xExtremes.userMin,xExtremes.userMax, true, true);
                    chart.yAxis[0].setExtremes(yExtremes.min, yExtremes.max, true, true);
                }, delayInMilliseconds);
            }
        });
    }

    document.getElementById("removeflag").onclick = async function() {
        
        let removeFlag = await $.ajax({
            url: `/api/nurses/removeflag/${flag_id}`,
            method: 'delete',
            contentType: 'application/json',
            error: function() {
                alert(arguments[0].responseJSON.err); 
            },
            success: function(){  
                editModal.hide();
                getChartData(patientId);
                setTimeout(function() {
                    chart.xAxis[0].setExtremes(xExtremes.userMin,xExtremes.userMax, true, true);
                    chart.yAxis[0].setExtremes(yExtremes.min, yExtremes.max, true, true);
                }, delayInMilliseconds);
            }
        });
    }

}
