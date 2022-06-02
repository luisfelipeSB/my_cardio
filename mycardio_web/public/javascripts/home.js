var nurseId;
var patientId;
var chart;
var chartexists = false;

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
              '<href="#" onclick="patientSelected('+patient.codigo+')" class="d-flex align-items-center">'+
                '<img src="images/flutteravatar.png" alt="Image" class="img-fluid mr-3">'+
                '<span class="user-name">'+patient.codigo+'</span>'+
              '</a>'+
            '</li>';

          document.getElementById("patients").innerHTML = patienthtml; 
    
        }



    } catch (err) {
    console.log(err);
    }
}

function patientSelected(codigo) {
    patientId = codigo;
    drawChart(patientId);
}

async function drawChart(patientId) {
    var data = [];
    var measureid = [];
    var flags = [];

    if(chartexists) {
        chart.destroy();
    }
    
    document.getElementById("toogleflag").style.visibility = "visible";

    let measures = await $.ajax({
        url: `/api/patients/${patientId}/measure/Distance`,
        method: "get",
        dataType: "json"
    });

    let measuresflags = await $.ajax({
        url: `/api/patients/${patientId}/measure/Distance/flags`,
        method: "get",
        dataType: "json",
        error: function() {
            //fazer
        },
        success: function(){  
            //fazer
        }
    });

    for (let measure of measures) {
        data.push({x: new Date(measure.instante), y: Number(measure.valor)});
        measureid.push(measure.medidaid);
    }
    console.log(data);

    for (let measureflag of measuresflags) {
        flags.push({x: new Date(measureflag.instant), title: measureflag.measure_flag_title, text:measureflag.measure_flag_text});
    }
    console.log(flags);
    
    chart = Highcharts.stockChart('container', {
        rangeSelector: {
            selected: 1
        },
        credits: {
            enabled: false
          },
          
          yAxis: {
            title: {
                text: 'Distance (m)'
            }
        },

        series: [{
            id: "Distance",
            turboThreshold: 0,
            name: 'Distance',
            data: data,
            tooltip: {
                valueDecimals: 2,
                valueSuffix: 'm',
            },
            events: {

                click: async function(event) {
                    let chartseries = this.chart.series[1];
                    let measure_id;

                    let time = new Date(event.point.x).getTime();
                    let date = new Date(time); // create Date object

                    let myModal = new bootstrap.Modal(document.getElementById('exampleModal'));

                    for (let i = 0; i < data.length; i++) {
                        if(time === data[i].x.getTime()) {
                            measure_id = measureid[i];
                            myModal.show();
                        }
                    }
                    

                    let createflagbutton = document.getElementById("createflag");

                    createflagbutton.onclick = async function() {

                        let title = document.getElementById("flagtitle").value;
                        let text = document.getElementById("flagtext").value;

                        let obj = {
                            measure_id: measure_id,
                            measure_title: document.getElementById("flagtitle").value,
                            measure_text: document.getElementById("flagtext").value
                        }

                        let newFlag = await $.ajax({
                            url: '/api/nurses/addflag',
                            method: 'post',
                            data: JSON.stringify(obj),
                            contentType: 'application/json',
                            error: function() {
                                alert(arguments[0].responseJSON.err); 
                                alert("nope");
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
        }, {
            type: 'flags',
            accessibility: {
                exposeAsGroupOnly: true,
                description: 'Flagged events.'
            },
            data: flags,
            onSeries: 'Distance',
            shape: 'circlepin',
            width: 16
        },{
            type: 'ohlc'
        }]
    });

    chartexists = true;
}

function addFlag() {

    document.getElementById("exampleModal").style.visibility = ""; 

}