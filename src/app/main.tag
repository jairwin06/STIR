<main>
    <h1>STIR</h1>
    <a href="/sleeper">Sleeper</a>
    <a href="/sleeper/alarms">Sleeper alarms</a>
    <role ref="role"></role>

    <style>
        main {
            display: block;
            background-color: #FC87FF;
        }
    </style>

    <script>
        import { mount } from 'riot'

        this.on('mount', () => {
            console.log("Main mounted");
            console.log("Current role ", this.state.main.role);
            //mount(this.refs.view, this.state.main.view);

            this.state.main.on('main_state_updated', this.viewUpdated);
        });

        this.on('unmount', () => {
            this.state.main.off('main_state_updated', this.viewUpdated);
        })

        viewUpdated(view) {
            console.log("Main state update!", view);
            //mount(this.refs.view, view);
        }
    </script>
</main>
