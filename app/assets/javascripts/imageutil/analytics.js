$(document).on('turbolinks:load',
  function(){
    // Set new default font family and font color to mimic Bootstrap's default styling
    Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
    Chart.defaults.global.defaultFontColor = '#292b2c';

    // Area Chart Example
    var ctx = document.getElementById("usageChart");
    if (ctx!=null){
      var myLineChart = new Chart(ctx, {
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
  });
