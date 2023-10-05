<template>
  <div class="w-full flex flex-between">
    <div v-if="canvasReady" class="w-36 mx-auto">
      <label class="text-gray-100 text-sm font-bold mt-5">
        Brush color
      </label>
      <input type="color" v-model="canvas.freeDrawingBrush.color" class="w-full"/>

      <span class="inline-flex justify-between h-12 items-center w-full">
        <label class="text-gray-100 text-sm font-bold mt-5">
          Brush size
        </label>
        <input type="number" min="1" max="100" v-model="canvas.freeDrawingBrush.width" class="ml-auto mt-2"/>
      </span>
      <input type="range" min="1" max="100" v-model="canvas.freeDrawingBrush.width" class="w-full mt-2"/>
    </div>
  </div>
</template>

<script lang="ts">
  export default {
    props: ['canvas', 'canvasReady'],
    data() {
      return {
        canvas: this.$props.canvas,
        canvasReady: this.$props.canvasReady,
      }
    },
    methods: {
    }
  }
</script>
