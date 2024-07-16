let Hooks = {};

Hooks.OpenDrawer = {
  mounted() {
    const element = document.getElementById("open-drawer");
    element.addEventListener("click", () => {
      const drawer = document.getElementById("drawer-container");
      if (drawer.classList.contains("-translate-x-full")) {
        drawer.classList.remove("-translate-x-full");
        drawer.classList.add("translate-x-0");
      } else {
        drawer.classList.add("translate-x-0");
      }
    });
  },
};

Hooks.CloseDrawer = {
  mounted() {
    const element = document.getElementById("close-drawer");
    element.addEventListener("click", () => {
      const drawer = document.getElementById("drawer-container");
      drawer.classList.remove("translate-x-0");
      drawer.classList.add("-translate-x-full");
    });
  },
};

export default Hooks;
