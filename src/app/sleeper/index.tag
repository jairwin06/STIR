<sleeper>
 <section id="sleeper">
     <h1>Sleeper</h1>
     <clock></clock>
 </section>
 <style>
 #sleeper {
    h1  {
     color: yellow;
    }
 }
 </style>
 <script>
    import './clock.tag'

    this.on('mount', () => {
        console.log("Sleeper mounted");
        
    });

    this.on('unmount', () => {
    });


 </script>
</sleeper>
