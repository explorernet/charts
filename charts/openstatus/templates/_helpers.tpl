{{- define "openstatus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openstatus.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "openstatus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{- define "openstatus.labels" -}}
helm.sh/chart: {{ include "openstatus.chart" . }}
app.kubernetes.io/name: {{ include "openstatus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "openstatus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openstatus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "openstatus.componentLabels" -}}
{{ include "openstatus.selectorLabels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{- define "openstatus.configName" -}}
{{- printf "%s-env" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.secretName" -}}
{{- printf "%s-env" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.libsqlName" -}}
{{- printf "%s-libsql" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.tinybirdName" -}}
{{- printf "%s-tinybird" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.workflowsName" -}}
{{- printf "%s-workflows" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.serverName" -}}
{{- printf "%s-server" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.privateLocationName" -}}
{{- printf "%s-private-location" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.dashboardName" -}}
{{- printf "%s-dashboard" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.statusPageName" -}}
{{- printf "%s-status-page" (include "openstatus.fullname" .) -}}
{{- end -}}

{{- define "openstatus.libsqlPvcName" -}}
{{- if .Values.libsql.persistence.existingClaim -}}
{{- .Values.libsql.persistence.existingClaim -}}
{{- else -}}
{{- printf "%s-libsql-data" (include "openstatus.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "openstatus.workflowsPvcName" -}}
{{- if .Values.workflows.persistence.existingClaim -}}
{{- .Values.workflows.persistence.existingClaim -}}
{{- else -}}
{{- printf "%s-workflows-data" (include "openstatus.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "openstatus.databaseUrl" -}}
{{- if .Values.libsql.enabled -}}
{{- printf "http://%s:%v" (include "openstatus.libsqlName" .) .Values.libsql.service.port -}}
{{- else -}}
{{- .Values.config.externalDatabaseUrl -}}
{{- end -}}
{{- end -}}

{{- define "openstatus.tinybirdUrl" -}}
{{- if .Values.tinybird.enabled -}}
{{- printf "http://%s:%v" (include "openstatus.tinybirdName" .) .Values.tinybird.service.port -}}
{{- else -}}
{{- .Values.config.externalTinybirdUrl -}}
{{- end -}}
{{- end -}}

{{- define "openstatus.dashboardUrl" -}}
{{- if .Values.config.publicUrl -}}
{{- .Values.config.publicUrl -}}
{{- else if and .Values.ingress.dashboard.enabled (gt (len .Values.ingress.dashboard.hosts) 0) -}}
{{- printf "https://%s" (index .Values.ingress.dashboard.hosts 0).host -}}
{{- end -}}
{{- end -}}

{{- define "openstatus.ingestUrl" -}}
{{- if .Values.config.openstatusIngestUrl -}}
{{- .Values.config.openstatusIngestUrl -}}
{{- else if and .Values.privateLocation.ingress.enabled (gt (len .Values.privateLocation.ingress.hosts) 0) -}}
{{- printf "https://%s" (index .Values.privateLocation.ingress.hosts 0).host -}}
{{- end -}}
{{- end -}}
