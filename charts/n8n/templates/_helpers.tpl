{{- define "n8n.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "n8n.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "n8n.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "n8n.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{- define "n8n.labels" -}}
helm.sh/chart: {{ include "n8n.chart" . }}
app.kubernetes.io/name: {{ include "n8n.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "n8n.selectorLabels" -}}
app.kubernetes.io/name: {{ include "n8n.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "n8n.componentLabels" -}}
{{ include "n8n.selectorLabels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{- define "n8n.envConfigName" -}}
{{- printf "%s-env" (include "n8n.fullname" .) -}}
{{- end -}}

{{- define "n8n.envSecretName" -}}
{{- printf "%s-env" (include "n8n.fullname" .) -}}
{{- end -}}

{{- define "n8n.serverName" -}}
{{- printf "%s-server" (include "n8n.fullname" .) -}}
{{- end -}}

{{- define "n8n.webhookName" -}}
{{- printf "%s-webhook" (include "n8n.fullname" .) -}}
{{- end -}}

{{- define "n8n.workerName" -}}
{{- printf "%s-worker" (include "n8n.fullname" .) -}}
{{- end -}}

{{- define "n8n.redisName" -}}
{{- printf "%s-redis" (include "n8n.fullname" .) -}}
{{- end -}}

{{- define "n8n.pvcName" -}}
{{- if .Values.persistence.existingClaim -}}
{{- .Values.persistence.existingClaim -}}
{{- else -}}
{{- printf "%s-data" (include "n8n.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "n8n.editorBaseUrl" -}}
{{- printf "https://%s" (index .Values.ingress.hosts 0).host -}}
{{- end -}}
