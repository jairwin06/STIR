<edit-alarm>
 <div id="edit-alarm">
    <h1 class="title">Edit Alarm</h1>
    <time></time>
    <button click="{cancelAlarm}" type="button">CANCEL ALARM</button>
 </div>
 <style>
  action #edit-alarm {
    h1 {
     color: cyan;
    }
    button {
        color: red;
    }
  }
 </style>
 <script>
    import './add-alarm/time.tag'

    this.on('mount', () => {
        console.log("edit-alarm mounted");
    });

    this.on('unmount', () => {
    });

    async cancelAlarm() {
        console.log("Cancel alarm!");
        try {
            let result = await this.state.sleeper.deleteAlarm();
            console.log("delete result", result);
            if (IS_CLIENT) {
                page("/sleeper");
            }
        } catch (e) {
            console.log("Error deleting alarm!", e);
        }
    }
 </script>
</edit-alarm>
