<template>
  <main class="bg-gray-700 flex-col justify-between items-center w-full h-screen">
    <section class="flex justify-between">
      <!-- Prompt -->
      <div class="w-full ml-10 my-10">
        <input
          v-model="prompt"
          :placeholder=currentImage.prompt
          class="w-8/12 pl-3 rounded-sm shadow h-12 text-gray-700 outline-none focus:placeholder:text-transparent"
        />

        <button
          @click="generate"
          class="ml-5 px-4 h-12 my-auto rounded-sm bg-gray-100 text-gray-800"
        >
          <spinner v-if="generating" />
          Generate
        </button>
      </div>
    </section>

    <section class="flex justify-between w-full">
      <!-- History -->
      <!-- <div v-if="imagesHistory.length" class="mt-5 text-gray-800 text-lg">
        <hr class="w-60 border-gray-700 border-dotted"/>

        <ol class="flex-col justify-center items-center h-96 mt-10">
          <li v-for="image in imagesHistory" :key="image.src" class="w-60 h-60 mt-5">
            <img
              :src="image.src"
              alt="image.prompt"
              @click="animate($event, image)"
              class="cursor-pointer hover:opacity-90"
            />
          </li>
        </ol>
      </div> -->

      <!-- Canvas -->
      <div class="ml-10 bg-black" @mousewheel.prevent.stop="panAndZoom">
        <canvas ref="canvas">
        </canvas>
      </div>

      <!-- Actions -->
      <div class="flex-col mx-auto">
        <button @click="open" class="block w-36 px-4 h-10 mt-10 rounded-sm bg-gray-100 text-gray-800">
          <spinner v-if="opening" />
          Open File
        </button>

        <button @click="edit" class="block w-36 px-4 h-10 mt-5 rounded-sm bg-gray-100 text-gray-800">
          <spinner v-if="editing" />
          Edit
        </button>

        <button @click="upscale" class="block w-36 px-4 h-10 mt-5 rounded-sm bg-gray-100 text-gray-800">
          <spinner v-if="upscaling" />
          Upscale
        </button>

        <button @click="fitToCanvas" class="block w-36 px-4 h-10 mt-5 rounded-sm bg-gray-100 text-gray-800">
          Fit to Canvas
        </button>
      </div>
    </section>
  </main>

  <!-- Hidden -->
  <input ref="imageInput" type="file" style="display:none"/>
</template>

<style scoped>
</style>

<script lang="ts">
import { fabric } from 'fabric'
import anime from 'animejs/lib/anime.es.js'

import Spinner from './Spinner.vue';

type Image = {
  id?: number,
  src: string,
  prompt: string,
}

const images : Image[] = [
  {
    src: "https://media.discordapp.net/attachments/1158089317739155497/1158421720768712815/lmomente_Mar_9f3db3dc-3b55-4976-8b34-18ab9e22d9c1.png?ex=651c2fcc&is=651ade4c&hm=f6dabec13a9b4aa7f01708029fe37f6744d309b96a937868a607908262f17f80&=&width=1528&height=1528",
    prompt: "A AI generated image",
  }, {
    src: "https://media.discordapp.net/attachments/1158089317739155497/1158425825155240007/lmomente_Mar_33aeff93-7138-4b4f-bca5-ee9421231df2.png?ex=651c339f&is=651ae21f&hm=88acd27bd83277d84186eb3fa8ec7457e9165b62fc7899ad3b648904d9883f8e&=&width=1528&height=1528",
    prompt: "A AI generated image",
  }
]

const getImage = () => images[Math.floor(Math.random() * 2)]

const BASE_URL = "http://localhost:3000"

const makeImage = (data : any) => ({
  id: data.id,
  src: data.url,
  prompt: data.prompt,
})

const makeDrawableImage = (url : string) : HTMLImageElement => {
  const image = new window.Image()
  image.src = url
  return image
}

export default {
  components: {
    'spinner': Spinner,
  },
  data() {
    return {
      userSelected: false,
      generating: false as boolean,
      upscaling: false as boolean,
      editing: false as boolean,
      opening: false as boolean,
      prompt: "" as string,
      currentImage: getImage() as Image,
      imagesHistory: [] as Image[],
      canvas: null as any,
    }
  },
  mounted() {
    const ref = this.$refs.canvas as HTMLCanvasElement
    this.canvas = new fabric.Canvas(ref)

    this.canvas.setHeight(window.innerHeight - 150)
    this.canvas.setWidth(window.innerWidth - 400)
    this.canvas.isDrawingMode = true
    this.canvas.freeDrawingBrush.width = 30
    this.canvas.freeDrawingBrush.color = "#ffffff"
    this.canvas.preserveObjectStacking = true

    const image = makeDrawableImage(this.currentImage.src)
    image.onload = () => this.renderImage(image)

    window.addEventListener('keydown', (event) => {
      if (event.key === 'Meta') {
        this.canvas.isDrawingMode = false
      }
    })

    window.addEventListener('keyup', (event) => {
      console.log(event.key)

      if (event.key === 'z') {
        event.preventDefault()
        event.stopPropagation()
        this.canvas.undo()
      } else if (event.key === 'Meta') {
        event.preventDefault()
        event.stopPropagation()
        this.canvas.isDrawingMode = true
      } else if (event.key === 'Backspace') {
        event.preventDefault()
        event.stopPropagation()
        this.canvas.remove(this.canvas.getActiveObject())
      }
    })

    window.addEventListener('resize', () => {
      this.canvas.setHeight(window.innerHeight - 150)
      this.canvas.setWidth(window.innerWidth - 400)
    })

    window.addEventListener('beforeunload', () => {
      this.canvas.dispose()
    })

    const imageInput = this.$refs.imageInput as HTMLInputElement
    imageInput.addEventListener("change", (event : any) => {
      this.currentImage = {
        src: URL.createObjectURL((event.target).files[0]),
        prompt: event.target.files[0].name.split('.')[0],
      }
      const image = makeDrawableImage(this.currentImage.src)
      image.onload = () => this.renderImage(image)
    })

    fetch(`${BASE_URL}/images`)
      .then(res => res.json())
      .then(data => this.imagesHistory = data.map((image: any) => (makeImage(image))))
  },
  methods: {
    renderImage(image : HTMLImageElement) {
      this.canvas.setBackgroundImage(image.src, this.canvas.renderAll.bind(this.canvas))
    },
    changeImage() {
      this.currentImage = getImage()
      return this.currentImage
    },
    generate() {
      this.generating = true

      fetch(`${BASE_URL}/images`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ image: { prompt: this.prompt }})
      })
        .then(res => res.json())
        .then((data) => {
          const newImage : Image = makeImage(data)
          this.currentImage = newImage
          this.imagesHistory.unshift(newImage)
          const drawableImage = makeDrawableImage(newImage.src)
          drawableImage.onload = () => this.renderImage(drawableImage)
          this.generating = false
        })
    },
    edit() {

    },
    upscale() {
      this.upscaling = true

      fetch(`${BASE_URL}/images/${this.currentImage.id}/upscale`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
      })
        .then(res => res.json())
        .then((data) => {
          const newImage : Image = makeImage(data)
          this.currentImage = newImage
          this.imagesHistory.unshift(newImage)
          this.upscaling = false
        })
    },
    open() {
      (this.$refs.imageInput as HTMLInputElement).click()
    },
    animate(event: any, image: Image) {
      this.userSelected = true
      this.currentImage = image

      anime({
        targets: event.target,
        translateX: 10,
        delay: anime.stagger(0)
      }).finished.then(() => {
        anime({
          targets: event.target,
          translateX: 0,
          delay: anime.stagger(0)
        });
      })
    },
    panAndZoom(event: any) {
      const delta = event.deltaY
      let zoom = this.canvas.getZoom()
      zoom *= 0.999 ** delta
      if (zoom >= 10 || zoom <= 0.4) return
      this.canvas.zoomToPoint({ x: event.offsetX, y: event.offsetY }, zoom)
    },
    fitToCanvas() {
      // Needs improvements to not cut the image
      this.canvas.setViewportTransform([1, 0, 0, 1, 0, 0])
    },
  }
}

</script>
