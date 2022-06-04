var nurseId;
var patientId;
var chart;
var chartexists = false;
var measure_type = "Heart Rate";
var measure_type2;
var measure_unit = "bpm";
var measure_unit2;
var nodata;

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

        document.getElementById("heartrate").onchange = function () {
            measure_type = "Heart Rate";
            measure_unit = "bpm";
            getChartData(patientId);
        };
        document.getElementById("bloodpressure").onchange = function () {
            measure_type = "Diastolic Blood Pressure";
            measure_type2 = "Systolic Blood Pressure";
            measure_unit = "mmHg";
            measure_unit2 = "mmHg";
            getChartData(patientId);
        };
        document.getElementById("weight").onchange = function () {
            measure_type = "Weight";
            measure_type2 = "Fat Ratio";
            measure_unit = "kg";
            measure_unit2 = "%";
            getChartData(patientId);
        };
        document.getElementById("steps").onchange = function () {
            measure_type = "Steps";
            measure_unit = "#";
            getChartData(patientId);
        };


    } catch (err) {
    console.log(err);
    }
}

function patientSelected(codigo) {
    document.getElementById("radiobuttons").style.visibility ="visible";
    patientId = codigo;
    getChartData(patientId);
}

async function getChartData(patientId) {
    let data = [];
    let measureid = [];
    let flags = [];

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
        data.push({x: new Date(measure.instante), y: Number(measure.valor)});
        measureid.push(measure.medidaid);
    }
    console.log(data);
    }   

    if(isIterable(measuresflags)) {
    for (let measureflag of measuresflags) {
        flags.push({x: new Date(measureflag.instant), title: measureflag.measure_flag_title, text:measureflag.measure_flag_text});
    }
    console.log(flags);
    } 

    if(document.getElementById("bloodpressure").checked || document.getElementById("weight").checked) {
        let data2 = [];
        let measureid2 = [];
        let flags2 = [];

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
            data2.push({x: new Date(measure2.instante), y: Number(measure2.valor)});
            measureid2.push(measure2.medidaid);
        }
        console.log(data2);
        }
    
        if(isIterable(measuresflags_second)) {
        for (let measureflag2 of measuresflags_second) {
            flags2.push({x: new Date(measureflag2.instant), title: measureflag2.measure_flag_title, text:measureflag2.measure_flag_text});
        }
        console.log(flags2);
        } 

        drawMultipleChart(data,measureid,flags,data2,measureid2,flags2);

    } else {
        drawChart(data,measureid,flags);
    }
}

async function drawChart(data,measureid,flags) {
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
                    let measure_id;
                    let time = new Date(event.point.x).getTime();
                    let myModal = new bootstrap.Modal(document.getElementById('exampleModal'));

                    for (let i = 0; i < data.length; i++) {
                        if(time === data[i].x.getTime()) {
                            measure_id = measureid[i];
                            myModal.show();
                        }
                    }

                    document.getElementById("createflag").onclick = async function() {

                        let title = document.getElementById("flagtitle").value;
                        let text = document.getElementById("flagtext").value;

                        let obj = {
                            measure_id: measure_id,
                            measure_title: title,
                            measure_text: text
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
                                myModal.hide();
                            }
                        });
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
            shape: 'circlepin',
            width: 16
        }]
    });

    chartexists = true;
}

async function drawMultipleChart(data,measureid,flags,data2,measureid2,flags2) {

    chart = Highcharts.stockChart('container', {
        rangeSelector: {
            selected: 1
        },
        credits: {
            enabled: false
          },
          
          yAxis: [{
            title: {
              text: 'First yAxis'
            },
          },
        ],

        xAxis: {
            ordinal: false
          },
          

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
                    let measure_id;
                    let time = new Date(event.point.x).getTime();
                    let myModal = new bootstrap.Modal(document.getElementById('exampleModal'));

                    for (let i = 0; i < data.length; i++) {
                        if(time === data[i].x.getTime()) {
                            measure_id = measureid[i];
                            myModal.show();
                        }
                    }

                    document.getElementById("createflag").onclick = async function() {

                        let title = document.getElementById("flagtitle").value;
                        let text = document.getElementById("flagtext").value;

                        let obj = {
                            measure_id: measure_id,
                            measure_title: title,
                            measure_text: text
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
                                myModal.hide();
                            }
                        });
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
            shape: 'circlepin',
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
                    let measure_id;
                    let time = new Date(event.point.x).getTime();
                    let myModal = new bootstrap.Modal(document.getElementById('exampleModal'));

                    for (let i = 0; i < data.length; i++) {
                        if(time === data[i].x.getTime()) {
                            measure_id = measureid2[i];
                            myModal.show();
                        }
                    }

                    document.getElementById("createflag").onclick = async function() {

                        let title = document.getElementById("flagtitle").value;
                        let text = document.getElementById("flagtext").value;

                        let obj = {
                            measure_id: measure_id,
                            measure_title: title,
                            measure_text: text
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
                                myModal.hide();
                            }
                        });
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
}

function isIterable(obj) {
    // checks for null and undefined
    if (obj == null) {
      return false;
    }
    return typeof obj[Symbol.iterator] === 'function';
}

