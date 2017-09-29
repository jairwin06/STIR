<dashboard>
 <section id="admin-dashboard">
     <h1 class="title">Dashboard</h1>
 </section>

 <style>
  #admin #admin-dashboard  {
    h1 {
     color: black;
    }
  }
 </style>
 <script>
    this.on('mount', () => {
        console.log("admin dashboard mounted");
    });

    this.on('unmount', () => {
    });

 </script>
</dashboard>
