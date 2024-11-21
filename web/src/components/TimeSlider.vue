<template>
  <div class="time-slider" ref="chart">
    <svg ref="svg"></svg>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, defineProps, defineEmits } from 'vue';
import * as d3 from 'd3';

const props = defineProps({
  data: {
    type: Array,
    required: true,
  },
});

const emits = defineEmits(['updateWindow']);

const svg = ref<SVGSVGElement | null>(null);
const chart = ref(null);

onMounted(() => {
  createChart();
});

watch(() => props.data, () => {
  createChart();
});

function createChart() {
  if (!svg.value) return;

  const margin = { top: 20, right: 30, bottom: 50, left: 50 };
  const width = svg.value.clientWidth - margin.left - margin.right;
  const height = 120 - margin.top - margin.bottom;

  // Clear previous chart
  d3.select(svg.value).selectAll('*').remove();

  const x = d3.scaleTime().range([0, width]);
  const y = d3.scaleLinear().range([height, 0]);

  const line = d3.line()
    .x((d: any) => x(new Date(d.time)))
    .y((d: any) => y(d.magnitude));

  const area = d3.area()
    .x((d: any) => x(new Date(d.time)))
    .y0(height)
    .y1((d: any) => y(d.magnitude));

  const svgElement = d3.select(svg.value)
    .attr('width', props.width)
    .attr('height', props.height)
    .append('g')
    .attr('transform', `translate(${margin.left},${margin.top})`);

  // Set the domains for the scales
  x.domain(d3.extent(props.data, (d: any) => new Date(d.time)) as [Date, Date]);
  const yMin = d3.min(props.data, (d: any) => d.magnitude) as number;
  const yMax = d3.max(props.data, (d: any) => d.magnitude) as number;
  y.domain([yMin - (yMax - yMin) * 0.1, yMax + (yMax - yMin) * 0.1]);

  // Add the area path
  svgElement
    .append('path')
    .datum(props.data)
    .attr('fill', 'steelblue')
    .attr('opacity', 0.2)
    .attr('d', area);

  // Add the line path
  svgElement
    .append('path')
    .datum(props.data)
    .attr('fill', 'none')
    .attr('stroke', 'steelblue')
    .attr('stroke-width', 2)
    .attr('d', line);

  // Add the "window" for the sub-section of the data
  const brush = d3.brushX()
    .extent([[0, 0], [width, height]])
    .on('brush end', brushed);

  svgElement.append('g')
    .attr('class', 'brush')
    .call(brush);


  // Add the x-axis
  const xAxis = d3.axisBottom(x)
    .ticks(d3.timeYear.every(1))
    .tickFormat(d3.timeFormat('%Y'));

  svgElement.append('g')
    .attr('transform', `translate(0,${height})`)
    .call(xAxis);

  function brushed(event: any) {
    if (event.selection) {
      const [x0, x1] = event.selection.map(x.invert);
      const [startIndex, endIndex] = [
        d3.bisector((d: any) => new Date(d.time)).left(props.data, x0),
        d3.bisector((d: any) => new Date(d.time)).left(props.data, x1)
      ];
      emits('updateWindow', { start: x0, end: x1, indexRange: [startIndex, endIndex] });
    }
  }
}
</script>

<style scoped>
.time-slider {
  width: 100%;
  overflow: hidden;
}

.time-slider svg {
  width: 100%;
  height: 120px;
}

.line {
  fill: none;
  stroke: steelblue;
  stroke-width: 2px;
}

.brush .selection {
  fill: #777;
  fill-opacity: 0.3;
  stroke: #fff;
  shape-rendering: crispEdges;
}
</style>