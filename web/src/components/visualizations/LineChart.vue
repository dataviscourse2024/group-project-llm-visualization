<template>
  <div ref="chart" class="chart"></div>
</template>

<script>
import { VContainer, VRow, VCol } from 'vuetify/components';
import { defineComponent } from 'vue';

import * as d3 from 'd3';

export default defineComponent({
  name: 'LineChart',
  data() {
    return {
      // data: [
      //   { date: new Date(2023, 0, 1), value: 30 },
      //   { date: new Date(2023, 1, 1), value: 50 },
      //   { date: new Date(2023, 2, 1), value: 80 },
      //   { date: new Date(2023, 3, 1), value: 65 },
      //   { date: new Date(2023, 4, 1), value: 95 }, 
      //   { date: new Date(2023, 5, 1), value: 70 },
      //   { date: new Date(2023, 6, 1), value: 85 },
      //   { date: new Date(2023, 7, 1), value: 60 },
      //   { date: new Date(2023, 8, 1), value: 75 },
      //   { date: new Date(2023, 9, 1), value: 90 },
      //   { date: new Date(2023, 10, 1), value: 100 },
      //   { date: new Date(2023, 11, 1), value: 110 },
      // ],
      data: []
    };
  },
  mounted() {
    // this.drawChart();
    d3.csv('./data/query.csv').then(dataOutput => {
      const dataResult = dataOutput.map(d => ({
        time: d3.timeFormat('%Y-%m-%d')(d3.timeParse('%Y-%m-%dT%H:%M:%S.%LZ')(d.time))
      }));

      const dateCounts = {};

      dataOutput.forEach(d => {
        const parsedDate = d3.timeFormat('%Y-%m-%d')(d3.timeParse('%Y-%m-%dT%H:%M:%S.%LZ')(d.time));
        if (dateCounts[parsedDate]) {
          dateCounts[parsedDate]++;
        } else {
          dateCounts[parsedDate] = 1;
        }
      });

      const dataArray = Object.keys(dateCounts).map(date => ({
        date: new Date(date),
        value: dateCounts[date],
      }));

      this.data = dataArray;

      this.drawChart();

      // console.log(dataResult);
      // console.log(dateCounts);
      // console.log(dataArray);
    }).catch(error => {
      console.error('Error loading the CSV data:', error);
    });
  },
  methods: {
    drawChart() {
      const margin = { top: 20, right: 30, bottom: 30, left: 40 };
      const width = this.$refs.chart.clientWidth - margin.left - margin.right;
      const height = this.$refs.chart.clientHeight - margin.top - margin.bottom;

      const svg = d3.select(this.$refs.chart)
        .append('svg')
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
        .append('g')
        .attr('transform', `translate(${margin.left},${margin.top})`);

      const x = d3.scaleTime()
        .domain(d3.extent(this.data, d => d.date))
        .range([0, width]);

      const y = d3.scaleLinear()
        .domain([0, d3.max(this.data, d => d.value)])
        .range([height, 0]);

      svg.append('g')
        .attr('transform', `translate(0,${height})`)
        .call(d3.axisBottom(x));

      svg.append('g')
        .call(d3.axisLeft(y));

      svg.append('path')
        .datum(this.data)
        .attr('fill', 'none')
        .attr('stroke', 'steelblue')
        .attr('stroke-width', 1.5)
        .attr('d', d3.line()
          .x(d => x(d.date))
          .y(d => y(d.value))
        );

      svg.append('path')
        .datum(this.data)
        .attr('fill', 'steelblue')
        .attr('opacity', 0.3)
        .attr('d', d3.area()
          .x(d => x(d.date))
          .y0(height)
          .y1(d => y(d.value))
        );

      const tooltip = d3.select(this.$refs.chart)
        .append('div')
        .style('position', 'absolute')
        .style('font-weight', 'bold')
        .style('border', '1px solid #ccc')
        .style('padding', '10px')
        .style('display', 'none')
        .style('pointer-events', 'none');

      svg.selectAll('circle')
        .data(this.data)
        .enter()
        .append('circle')
        .attr('cx', d => x(d.date))
        .attr('cy', d => y(d.value))
        .attr('r', 4)
        .attr('fill', 'steelblue')
        .on('mouseover', function(event, d) {
          d3.select(this).attr('fill', 'orange');
          tooltip.style('display', 'block')
            .style('left', `${event.pageX + 10}px`)
            .style('top', `${event.pageY - 28}px`)
            .html(`Date: ${d.date}<br>Value: ${d.value}`);
        })
        .on('mouseout', function(event, d) {
          d3.select(this).attr('fill', 'steelblue');
          tooltip.style('display', 'none');
        });

      d3.select(this.$refs.chart)
        .on('click', function(event) {
          if (!event.target.closest('circle')) {
            tooltip.style('display', 'none');
          }
        });

    },
  },
});
</script>

<style scoped>
.chart {
  width: 100%;
  height: 100%;
}
</style>