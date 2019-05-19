$(document).on('turbolinks:load',
  function(){
    // Set new default font family and font color to mimic Bootstrap's default styling
    Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
    Chart.defaults.global.defaultFontColor = '#292b2c';

    // Area Chart Example
    var ctx1 = document.getElementById("usageChart");
    if (ctx1!=null){
      var myLineChart = new Chart(ctx1, {
        type: 'line',
        data: {
          labels: days_in_month,
          datasets: [{
            label: "Unique Requests",
            lineTension: 0.0,
            backgroundColor: "rgba(2,117,216,0.2)",
            borderColor: "rgba(2,117,216,1)",
            pointRadius: 3,
            pointBackgroundColor: "rgba(2,117,216,1)",
            pointBorderColor: "rgba(255,255,255,0.8)",
            pointHoverRadius: 3,
            pointHoverBackgroundColor: "rgba(2,117,216,1)",
            pointHitRadius: 50,
            pointBorderWidth: 1,
            data: uniq_count_in_month,
          },
          {
            label: "Total Requests",
            lineTension: 0.0,
            backgroundColor: "rgba(2,216,117,0.2)",
            borderColor: "rgba(2,216,117,1)",
            pointRadius: 3,
            pointBackgroundColor: "rgba(2,216,117,1)",
            pointBorderColor: "rgba(255,255,255,0.8)",
            pointHoverRadius: 3,
            pointHoverBackgroundColor: "rgba(2,216,117,1)",
            pointHitRadius: 50,
            pointBorderWidth: 1,
            data: total_count_in_month,
          }],
        },
        options: {
          scales: {
            xAxes: [{
              time: {
                unit: 'date'
              },
              gridLines: {
                display: false
              },
              ticks: {
                maxTicksLimit: 5
              }
            }],
            yAxes: [{
              ticks: {
                min: 0,
                max: max_limit,
                maxTicksLimit: 100
              },
              gridLines: {
                color: "rgba(0, 0, 0, .125)",
              }
            }],
          },
          legend: {
            display: true
          }
        }
      });
    }

    var ctx2 = document.getElementById('bandWidthChart').getContext("2d");
    if (ctx2!=null){
      myChart = new Chart(ctx2, {
        type: 'pie',
        data: {
          labels: ['Total Bandwidth', 'Used Bandwith'],
          datasets: [{
            label: "Bandwidth",
            pointRadius: 0,
            pointHoverRadius: 0,
            backgroundColor: [
              '#4acccd',
              '#fcc468'
            ],
            borderWidth: 0,
            data: [max_bytes_limit, total_bytes]
          }]
        },

        options: {

          legend: {
            display: true
          },

          pieceLabel: {
            render: 'percentage',
            fontColor: ['black'],
            precision: 2
          },

          tooltips: {
            enabled: false
          },

          scales: {
            yAxes: [{

              ticks: {
                display: false
              },
              gridLines: {
                drawBorder: false,
                zeroLineColor: "transparent",
                color: 'rgba(255,255,255,0.05)'
              }

            }],

            xAxes: [{
              barPercentage: 1.6,
              gridLines: {
                drawBorder: false,
                color: 'rgba(255,255,255,0.1)',
                zeroLineColor: "transparent"
              },
              ticks: {
                display: false,
              }
            }]
          },
        }
      });
    }
  });
