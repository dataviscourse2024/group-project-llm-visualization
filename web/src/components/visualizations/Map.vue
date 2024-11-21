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
import { onMounted, ref, reactive, computed } from 'vue';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import utahTopoJson from './utah.json'; // Import the TopoJSON file for Utah

const props = defineProps({
  data: Array,
});

const chart = ref(null);
const selectedData = reactive([]);
const formatDate = (time) => d3.timeFormat("%B %d, %Y")(new Date(time));
const formatTime = (time) => d3.timeFormat("%H:%M:%S")(new Date(time));

const reversedSelectedData = computed(() => [...selectedData].reverse());

const drawMap = () => {
  const width = 800;
  const height = 600;

  const svg = d3.select(chart.value)
    .append('svg')
    .attr('width', width)
    .attr('height', height);

  const projection = d3.geoMercator()
    .center([-111.5, 39.5]) // Center the map on Utah
    .scale(5000) // Adjust the scale as needed
    .translate([width / 2, height / 2]);

  const path = d3.geoPath().projection(projection);

  const g = svg.append('g');

  // Draw the map of Utah
  g.selectAll('path')
    .data(topojson.feature(utahTopoJson, utahTopoJson.objects.utah).features)
    .enter()
    .append('path')
    .attr('d', path)
    .attr('fill', '#ccc')
    .attr('stroke', '#333');

  // Draw the points
  svg.selectAll('circle')
    .data(props.data)
    .enter()
    .append('circle')
    .attr('cx', (d) => projection([d.longitude, d.latitude])[0])
    .attr('cy', (d) => projection([d.longitude, d.latitude])[1])
    .attr('r', 5)
    .attr('fill', 'red')
    .on('mouseover', (event, d) => {
      tooltip.transition().duration(200).style('opacity', 1);
      tooltip.html(`Date: ${formatDate(d.time)}<br>Magnitude: ${d.magnitude}<br>Location: ${d.location}<br>Time: ${formatTime(d.time)}`)
        .style('left', `${event.pageX + 10}px`)
        .style('top', `${event.pageY - 28}px`);
      d3.select(event.currentTarget).attr('fill', 'orange');
    })
    .on('mouseout', function () {
      tooltip.transition().duration(500).style('opacity', 0);
      d3.select(this).attr('fill', 'red');
    });

  const tooltip = d3.select(chart.value).append('div')
    .attr('class', 'tooltip')
    .style('opacity', 0)
    .style('position', 'absolute')
    .style('padding', '10px')
    .style('font-weight', 'bold')
    .style('border', '1px solid #ccc')
    .style('border-radius', '4px');

  d3.select(chart.value)
    .on('click', function (event) {
      if (!event.target.closest('circle')) {
        tooltip.style('opacity', 0);
      }
    });

  const brush = d3.brush()
    .extent([[0, 0], [width, height]])
    .on('end', brushed);

  svg.append('g')
    .attr('class', 'brush')
    .call(brush);

  function brushed(event) {
    if (!event.selection) {
      selectedData.splice(0, selectedData.length); // Clear the table when brush is out of focus
      return;
    }
    const [[x0, y0], [x1, y1]] = event.selection;
    const brushedData = props.data.filter(d => {
      const [cx, cy] = projection([d.longitude, d.latitude]);
      return cx >= x0 && cx <= x1 && cy >= y0 && cy <= y1;
    });
    selectedData.splice(0, selectedData.length, ...brushedData);
  }
};

onMounted(drawMap);
</script>

<style scoped>
.chart {
  width: 100%;
  height: 600px;
}

.tooltip {
  font-size: 12px;
  pointer-events: none;
}

.table-container {
  max-height: 200px; /* Set the maximum height for the table container */
  overflow-y: auto; /* Enable vertical scrolling */
  margin-top: 20px;
}

table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
}

th {
  background-color: #f2f2f2;
  text-align: left;
}
</style>