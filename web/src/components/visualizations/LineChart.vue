<template>
  <div ref="chart" class="chart"></div>
</template>

<script setup lang="ts">
import { onMounted, watch, ref } from 'vue';
import * as d3 from 'd3';

const props = defineProps({
  data: Array,
});

const chart = ref(null);

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
    .range([height, 0]);

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
    .style('opacity', 0)
    .style('position', 'absolute')
    .style('background', 'rgba(255, 255, 255, 0.9)')
    .style('padding', '8px')
    .style('border', '1px solid #ccc')
    .style('border-radius', '4px');

  svg.selectAll('circle')
    .data(props.data)
    .enter()
    .append('circle')
    .attr('cx', (d) => x(new Date(d.time)))
    .attr('cy', (d) => y(d.magnitude))
    .attr('r', 5)
    .attr('fill', 'steelblue')
    .on('mouseover', (event, d) => {
      tooltip.transition().duration(200).style('opacity', 1);
      tooltip.html(`Date: ${d3.timeFormat("%B %d, %Y")(new Date(d.time))}<br>Magnitude: ${d.magnitude}<br>Title: ${d.location}`)
        .style('left', `${event.pageX + 10}px`)
        .style('top', `${event.pageY - 28}px`);
      d3.select(event.currentTarget).attr('fill', 'orange');
    })
    .on('mouseout', function () {
      tooltip.transition().duration(500).style('opacity', 0);
      d3.select(this).attr('fill', 'steelblue');
    });

  d3.select(chart.value)
    .on('click', function (event) {
      if (!event.target.closest('circle')) {
        tooltip.style('opacity', 0);
      }
    });
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
</style>
