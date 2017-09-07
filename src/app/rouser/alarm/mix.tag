<mix>
    <h1 class="title">Mix your recording</h1>
    <p>
        <audio controls="controls">
            <source src={state.rouser.recording.recordingUrl} type="audio/wav">
        </audio>
    </p>

    <style>
    </style>
    <script>
        this.on('mount', () => {
            console.log("alarm mix mounted");
                    
        });

        this.on('unmount', () => {

        });
    </script>
</mix>

