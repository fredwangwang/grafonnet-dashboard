local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;
local template = grafana.template;
local graphPanel = grafana.graphPanel;

local metrics = import 'metrics.json';

local systemHealthy = graphPanel.new(
  title=metrics.systemHealthy.title,
  datasource=null,
  linewidth=2,
).addTarget(
  prometheus.target(
    metrics.systemHealthy.expr,
  )
);

local cpu = graphPanel.new(
  title=metrics.cpu.title,
  datasource=null,
  linewidth=2,
).addTarget(
  prometheus.target(
    metrics.cpu.expr,
  )
);


local memory = graphPanel.new(
  title=metrics.memory.title,
  datasource=null,
  linewidth=2,
).addTarget(
  prometheus.target(
    metrics.memory.expr,
  )
);


dashboard.new(
  'Sample Dashboard',
  schemaVersion=16,
  editable=true,
  time_from='now-6h',
  refresh='1m',
)
.addTemplate(
  grafana.template.datasource(
    'PROMETHEUS_DS',
    'prometheus',
    'Prometheus',
    label='Prometheus',
  )
)
.addTemplate(
  template.new(
    'instance',
    '$PROMETHEUS_DS',
    'label_values(system_healthy, instance)',
    label='Instance',
    refresh='time',
  )
)
.addPanels(
  [
    systemHealthy { gridPos: { h: 8, w: 24, x: 0, y: 0 } },
    cpu { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
    memory { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
  ],
)

// useful tutorial: https://0x63.me/grafana-dashboards-as-code-with-grafonnet-lib/



