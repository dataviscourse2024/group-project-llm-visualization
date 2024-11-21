<template>
  <div ref="chart" class="chart"></div>
  <div class="table-container" v-if="selectedData.length">
    <table>
      <thead>
        <tr>
          <th>Date</th>
          <th>Magnitude</th>
          <th>Location</th>
          <th>Time</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="data in reversedSelectedData" :key="data.time">
          <td>{{ formatDate(data.time) }}</td>
          <td>{{ data.magnitude }}</td>
          <td>{{ data.location }}</td>
          <td>{{ formatTime(data.time) }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
import { onMounted, watch, ref, reactive, computed } from 'vue';
import * as d3 from 'd3';
import { currentSelection } from '../../store';

const props = defineProps({
  data: Array,
});

const chart = ref(null);
const selectedData = reactive([]);
const formatDate = (time) => d3.timeFormat("%B %d, %Y")(new Date(time));
const formatTime = (time) => d3.timeFormat("%I:%M %p")(new Date(time));
const reversedSelectedData = computed(() => [...selectedData].reverse());

const drawChart = () => {
  const margin = { top: 20, right: 30, bottom: 50, left: 50 };
  const width = chart.value.clientWidth - margin.left - margin.right;
  const height = chart.value.clientHeight - margin.top - margin.bottom;
  d3.select(chart.value).selectAll('*').remove();

  const svg = d3
    .select(chart.value)
    .append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', `translate(${margin.left},${margin.top})`);

  const x = d3
    .scaleTime()
    .domain(d3.extent(props.data, (d) => new Date(d.time)))
    .range([0, width]);

  const y = d3
    .scaleLinear()
    .domain([0, d3.max(props.data, (d) => d.magnitude)])
    .range([height, 0])
    .nice();

  svg.append('g')
    .attr('transform', `translate(0,${height})`)
    .call(d3.axisBottom(x).tickFormat(d3.timeFormat("%b %d")));

  svg.append('g')
    .call(d3.axisLeft(y));

  const line = d3
    .line()
    .x((d) => x(new Date(d.time)))
    .y((d) => y(d.magnitude));

  const area = d3
    .area()
    .x((d) => x(new Date(d.time)))
    .y0(height)
    .y1((d) => y(d.magnitude));

  svg
    .append('path')
    .datum(props.data)
    .attr('fill', 'steelblue')
    .attr('opacity', 0.2)
    .attr('d', area);

  svg
    .append('path')
    .datum(props.data)
    .attr('fill', 'none')
    .attr('stroke', 'steelblue')
    .attr('stroke-width', 2)
    .attr('d', line);

  const tooltip = d3
    .select(chart.value)
    .append('div')
    .attr('class', 'tooltip')
    .style('background', 'rgba(255,255,255,0.7)')
    .style('position', 'absolute')
    .style('padding', '10px')
    .style('font-weight', 'bold')
    .style('border', '1px solid #ccc')
    .style('border-radius', '4px');

  const brush = d3.brushX()
    .extent([[0, 0], [width, height]])
    .on('end', brushed);
  
  svg.append('g')
    .attr('class', 'brush')
    .call(brush);

  svg.selectAll('path')
    .data(props.data)
    .enter()
    .append('path')
    .attr('d', d3.symbol().type(d => d.type === 'earthquake' ? d3.symbolCircle : d3.symbolTriangle).size(100))
    .attr('transform', d => `translate(${x(new Date(d.time))},${y(d.magnitude)})`)
    .attr('fill', d => d.type === 'earthquake' ? 'steelblue' : 'green')
    .on('mouseover', (event, d) => {
      tooltip.transition().duration(200).style('opacity', 1);
      tooltip.html(`Date: ${formatDate(d.time)}<br>Magnitude: ${d.magnitude}<br>Title: ${d.location}<br>Time: ${formatTime(d.time)}`)
        .style('left', `${event.pageX + 10}px`)
        .style('top', `${event.pageY - 28}px`);
      d3.select(event.currentTarget).attr('fill', 'orange');
    })
    .on('mouseout', function (event, d) {
      tooltip.transition().duration(500).style('opacity', 0);
      d3.select(this).attr('fill', d.type === 'earthquake' ? 'steelblue' : 'green');
    });


    const legend = svg.append('g')
      .attr('class', 'legend')
      .attr('transform', `translate(${width - 100},${margin.top})`);

    legend.append('circle')
      .attr('cx', 0)
      .attr('cy', 0)
      .attr('r', 5)
      .attr('fill', 'steelblue');

    legend.append('text')
      .attr('x', 10)
      .attr('y', 5)
      .text('Earthquake')
      .style('font-size', '12px')
      .attr('alignment-baseline', 'middle');

    legend.append('path')
      .attr('d', d3.symbol().type(d3.symbolTriangle).size(100))
      .attr('transform', 'translate(0, 20)')
      .attr('fill', 'green');

    legend.append('text')
      .attr('x', 10)
      .attr('y', 25)
      .text('Mining Explosion')
      .style('font-size', '12px')
      .attr('alignment-baseline', 'middle');

  d3.select(chart.value)
    .on('click', function (event) {
      if (!event.target.closest('circle')) {
        tooltip.style('opacity', 0);
      }
    });

  function brushed(event) {
    if (!event.selection) {
      selectedData.splice(0, selectedData.length); // Clear the table when brush is out of focus
      return;
    }
    const [x0, x1] = event.selection.map(x.invert);
    const brushedData = props.data.filter(d => {
      const time = new Date(d.time);
      return time >= x0 && time <= x1;
    });
    selectedData.splice(0, selectedData.length, ...brushedData);
    currentSelection.value = selectedData;
  }
};

onMounted(drawChart);
watch(() => props.data, drawChart);
</script>

<style scoped>
.chart {
  width: 100%;
  height: 400px;
}

.tooltip {
  font-size: 12px;
  pointer-events: none;
}

.table-container {
  max-height: 200px; /* Set the maximum height for the table container */
  overflow-y: auto; /* Enable vertical scrolling */
  margin-top: 20px;
  width: 100%;
  position: relative;
}

table {
  border-collapse: collapse;
  width: 100%;
  margin: 0;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
}

th {
  border: 1px solid #ddd;
  text-align: left;
}

thead {
  position: sticky;
  top: 0;
  z-index: 1;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  background-image: linear-gradient(to right, #ffffff, #f7f7f7); 
}
.v-theme--dark thead {
  background-image: linear-gradient(to right, #333333, #444444); 
}

tr:nth-child(even) {
  background-image: linear-gradient(to right, #f2f2f2, #e0e0e0); 
}

.v-theme--dark tr:nth-child(even) {
  background-image: linear-gradient(to right, #444444, #555555); 
}
</style>
