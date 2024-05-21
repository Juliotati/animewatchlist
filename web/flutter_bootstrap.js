{{flutter_js}}
{{flutter_build_config}}

window.addEventListener('load', function (ev) {
    _flutter.loader.loadEntrypoint({
        serviceWorker: {
            serviceWorkerVersion: {{flutter_service_worker_version}},
        },
        onEntrypointLoaded: function (engineInitializer) {
            engineInitializer.initializeEngine({
                useColorEmoji: true,
            }).then(function (appRunner) {
                appRunner.runApp();
            });
        }
    });
});