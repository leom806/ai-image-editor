<template>
  <main class="bg-gray-700 flex-col w-full h-screen overflow-hidden">
    <div @mousewheel.prevent.stop="panAndZoom">
      <canvas ref="canvas" :width="canvasWidth" :height="canvasHeight">
      </canvas>
    </div>

    <div class="inline-flex w-full h-max">
      <div class="m-5 w-1/2 grid grid-flow-col grid-rows-3 grid-cols-6 gap-2">
        <img
          :src="image.src"
          class="rounded-sm cursor-pointer hover:opacity-90"
          v-for="image in imagesHistory"
          @click="renderImage(image)"
        />
      </div>

      <section class="ml-auto w-1/2 flex justify-between p-5">
        <textarea
          v-model="prompt"
          placeholder="Let your imagination run wild!"
          class="resize-none w-full p-3 rounded-sm shadow text-gray-700 outline-none focus:placeholder:text-transparent"
        ></textarea>

        <actions
          :prompt="prompt"
          :canvas="canvas"
          :imageInput="$refs.imageInput"
          class="ml-5"
          @image-generated="addImageToHistory"
        />
      </section>
    </div>
  </main>

  <!-- Hidden -->
  <input ref="imageInput" type="file" style="display:none"/>
</template>

<style scoped>
</style>

<script lang="ts">
import { fabric } from 'fabric'
// import anime from 'animejs/lib/anime.es.js'

import Actions from './Actions.vue';
import Spinner from './Spinner.vue';

export default {
  components: {
    'spinner': Spinner,
    'actions': Actions,
  },
  data() {
    return {
      prompt: "" as string,
      imagesHistory: [] as any[],
      canvas: null as any,
      canvasWidth: window.innerWidth,
      canvasHeight: window.innerHeight - 400,
    }
  },
  mounted() {
    loadInitialData.bind(this)()
    setUpCanvas.bind(this)()
    setListeners.bind(this)()
  },
  methods: {
    renderImage(image : HTMLImageElement) {
      this.canvas.setBackgroundImage(image.src, this.canvas.renderAll.bind(this.canvas))
    },
    panAndZoom(event: any) {
      const delta = event.deltaY
      let zoom = this.canvas.getZoom()
      zoom *= 0.999 ** delta
      if (zoom >= 10 || zoom <= 0.2) return
      this.canvas.zoomToPoint({ x: event.offsetX, y: event.offsetY }, zoom)
    },
    addImageToHistory(event : any, data : any) {
      console.log(event, data)
      const image = makeDrawableImage(event.src)
      image.onload = () => {
        this.imagesHistory.unshift({ src: image.src, prompt: event.prompt })
        this.renderImage(image)
      }
    },
  }
}

/**
 * Private methods
 */

const makeDrawableImage = (url : string) : HTMLImageElement => {
  const image = new window.Image()
  image.src = url
  return image
}

/**
 * Do not use arrow function here as it won't bind `this` to the component
 */

const loadInitialData = function() {
  this.$api
    .getImages()
    .then((data) => {
      this.imagesHistory = data.map((image : any) => makeDrawableImage(image.url))
    })
}

const setUpCanvas = function() {
  const ref = this.$refs.canvas as HTMLCanvasElement
  this.canvas = new fabric.Canvas(ref)

  this.canvas.isDrawingMode = true
  this.canvas.freeDrawingBrush.width = 30
  this.canvas.freeDrawingBrush.color = "#ffffff"
  this.canvas.preserveObjectStacking = true
  this.canvas.backgroundColor = "#000000"

  if (this.imagesHistory.length > 0) {
    const image = makeDrawableImage(this.imagesHistory[0].src)
    image.onload = () => this.renderImage(image)
  }
}

const setListeners = function () {
  window.addEventListener('keydown', (event) => {
    if (event.key === 'Meta') {
      this.canvas.isDrawingMode = false
    }
  })

  window.addEventListener('keyup', (event) => {
    event.preventDefault()
    event.stopPropagation()

    if (event.key === 'z') {
      this.canvas.undo()
    } else if (event.key === 'Meta') {
      this.canvas.isDrawingMode = true
    } else if (event.key === 'Backspace') {
      this.canvas.remove(this.canvas.getActiveObject())
    }
  })

  window.addEventListener('resize', () => {
    this.canvas.setHeight(window.innerHeight - 400)
    this.canvas.setWidth(window.innerWidth)
  })

  window.addEventListener('beforeunload', () => {
    this.canvas.dispose()
  })

  const imageInput = this.$refs.imageInput as HTMLInputElement
  imageInput.addEventListener("change", (event : any) => {
    const image = makeDrawableImage(URL.createObjectURL((event.target).files[0]))
    image.onload = () => this.renderImage(image)
  })
}

</script>
