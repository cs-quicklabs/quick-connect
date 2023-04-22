import { Controller } from "@hotwired/stimulus"
import { Chart } from "frappe-charts/dist/frappe-charts.min.esm"

export default class extends Controller {
  static targets = ["chart"];
  connect() {
    const chartData = { labels: ["Mon", "Tue", "Wed", "Thu", "Fri"],
    datasets: [
      {
        name: "Dataset 1",
        values: [18, 40, 30, 35, 8],
      },
      {
        name: "Dataset 2",
        values: [30, 50, 25, 50, 10],
      },
    ]
  };
  const chartOptions = {
    title: "My Chart",
    type: "heatmap",
    height: 250,
    colors: ["#7cd6fd", "#743ee2", "#fcd34d", "#ff6c5c", "#a5c8e1"],
  };

  


    let chart = new Chart(this.chartTarget, {
      data: chartData,
      ...chartOptions
  });
  }
}