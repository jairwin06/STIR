<edit-alarm>
 <h1 class="title">Edit Alarm</h1>
 <time></time>
 <style>
  #sleeper alarms edit-alarm {
    h1 {
     color: green;
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
 </script>
</edit-alarm>
