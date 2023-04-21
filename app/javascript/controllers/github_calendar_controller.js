// app/javascript/controllers/github_contributions_controller.js

import { Controller } from "@hotwired/stimulus"


import GitHubCalendar from 'github-calendar';

export default class extends Controller {
  
    
    connect() {
      const legend = [
        { color: "--color-awesome", value: 0, text: "Awesome" },
        { color: "--color-normal", value: 1, text: "Normal" },
        { color: "--color-bad", value: 2, text: "Bad" },
      ];
          const username = this.data.get('username');
          const data = JSON.parse(this.data.get('data'));
          const cal = this.element.querySelector(".calendar-graph");
          const legendEls = this.element.querySelectorAll(".calendar-legend span");
      
          
          GitHubCalendar(cal, username, {
            responsive: true,
            tooltips: true,
            legend: legend,
            global_stats: false,
            cache: false,
            data: data,
            summary_text: "",
            endDate: new Date().toISOString(),
            startDate: new Date(new Date().setMonth(new Date().getMonth() - 3)).toISOString(),
          });
        }
      }