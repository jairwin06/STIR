<mturk>
 <h1 class="title">Record a message</h1>
  <div id="prompt">
  <p>
  {state.rouser.currentAlarm.prompt}
  </p>
  </div>
  <img show="{loading}" src="/images/loading.gif"></img>
   <b show"{error}" class="error">{error}</b>
 <style>
 </style>
 <script>
    this.on('mount', () => {
        console.log("alarm record mturk mounted");
    });

    this.on('unmount', () => {
    });
 </script>
</record>
