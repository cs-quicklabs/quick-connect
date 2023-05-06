import Chart from "stimulus-chartjs";

export default class extends Chart {
  connect() {
    super.connect();

    // The chart.js instance
    this.chart;

    // Options from the data attribute.
    this.options;

    // Default options for every charts.
    this.defaultOptions;
  }

  // You can set default options in this getter for all your charts.
  get defaultOptions() {
    return {
      maintainAspectRatio: true,
      legend: {
        display: false,
      },
    };
  }
}
