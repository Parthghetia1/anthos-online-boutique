# frontend deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: frontend
spec:
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
      annotations:
        sidecar.istio.io/rewriteAppHTTPProbers: "true"
    spec:
      serviceAccountName: frontend
      containers:
        - name: server
          image: gcr.io/GOOGLE_CLOUD_PROJECT/frontend@COMMIT_SHA
          ports:
          - containerPort: 8080
          readinessProbe:
            initialDelaySeconds: 10
            httpGet:
              path: "/_healthz"
              port: 8080
              httpHeaders:
              - name: "Cookie"
                value: "shop_session-id=x-readiness-probe"
          livenessProbe:
            initialDelaySeconds: 10
            httpGet:
              path: "/_healthz"
              port: 8080
              httpHeaders:
              - name: "Cookie"
                value: "shop_session-id=x-liveness-probe"
          env:
          - name: PORT
            value: "8080"
          - name: PRODUCT_CATALOG_SERVICE_ADDR
            value: "productcatalogservice.product-catalog.svc.cluster.local:3550"
          - name: CURRENCY_SERVICE_ADDR
            value: "currencyservice.currency.svc.cluster.local:7000"
          - name: CART_SERVICE_ADDR
            value: "cartservice.cart.svc.cluster.local:7070"
          - name: RECOMMENDATION_SERVICE_ADDR
            value: "recommendationservice.recommendation.svc.cluster.local:8080"
          - name: SHIPPING_SERVICE_ADDR
            value: "shippingservice.shipping.svc.cluster.local:50051"
          - name: CHECKOUT_SERVICE_ADDR
            value: "checkoutservice.checkout.svc.cluster.local:5050"
          - name: AD_SERVICE_ADDR
            value: "adservice.ad.svc.cluster.local:9555"
          # # ENV_PLATFORM: One of: local, gcp, aws, azure, onprem
          # # When not set, defaults to "local" unless running in GKE, otherwies auto-sets to gcp 
          # - name: ENV_PLATFORM 
          #   value: "aws"
          - name: DISABLE_TRACING
            value: "1"
          - name: DISABLE_PROFILER
            value: "1"
          # - name: JAEGER_SERVICE_ADDR
          #   value: "jaeger-collector:14268"
          resources:
            requests:
              cpu: 100m
              memory: 64Mi
            limits:
              cpu: 200m
              memory: 128Mi