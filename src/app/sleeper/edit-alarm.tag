<edit-alarm>
 <div id="edit-alarm">
    <h1 class="title">Edit Alarm</h1>
    <time></time>
    <button type="button">CANCEL ALARM</button>
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
 </script>
</edit-alarm>
