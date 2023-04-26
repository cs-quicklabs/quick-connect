import { Controller } from "@hotwired/stimulus"
import Chart from 'stimulus-chartjs'

export default class extends Chart {
  connect() {
    super.connect()
    console.log('Do what you want here.')

    // The chart.js instance
    this.chart

    // Options from the data attribute.
    this.options

    // Default options for every charts.
    this.defaultOptions
  }

  // Bind an action on this method
  async update() {
    const response = await fetch('https://example.com/chart_data.json')
    const data = await response.json()

    this.chart.data = data
    this.chart.update()
  }

  // You can set default options in this getter for all your charts.
  get defaultOptions() {
    return {
      maintainAspectRatio: true,
      legend: {
        display: false,
      },
    }
  }
}