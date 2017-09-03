<record>
 <h1 class="title">Record a message</h1>
  <div id="prompt">
  {state.rouser.currentAlarm.prompt}
  </div>
  <form onsubmit="{next}">
    Recording:<input type="file" accept="audio/*" capture="microphone">
    <input type="submit" value="Next">
  </form>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarm record mounted");
    });

    this.on('unmount', () => {
    });


    next(e) {
        e.preventDefault();
    }
 </script>
</record>
