<template>
  <div class="flex-col my-auto">
    <button @click="generate" class="block w-36 px-4 h-10 rounded-sm bg-gray-100 text-gray-800">
      <spinner v-if="generating" />
      Generate
    </button>

    <button @click="open" class="block w-36 px-4 h-10 mt-5 rounded-sm bg-gray-100 text-gray-800">
      <spinner v-if="opening" />
      Open File
    </button>

    <button :disabled="!canUpload" @click="upload" class="block w-36 px-4 h-10 mt-5 rounded-sm bg-gray-100 text-gray-800 disabled:text-gray-400 disabled:cursor-not-allowed">
      <spinner v-if="uploading" />
      Upload
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
</template>


<script lang="ts">
  import Spinner from './Spinner.vue'

  export default {
    components: {
      'spinner': Spinner,
    },
    props: ['canvas', 'imageInput', 'prompt', 'canUpload'],
    data() {
      return {
        generating: false,
        opening:    false,
        uploading:  false,
        editing:    false,
        upscaling:  false,
      }
    },
    methods: {
      generate() {
        this.generating = true

        this.$api
          .generateImage({ image: { prompt: this.$props.prompt }})
          .then((image : any) => {
            this.$emit('image-generated', { src: image.url })
            this.generating = false
          })
          .catch((error) => {
            console.error(error)
            this.generating = false
          })
      },
      open() {
        this.imageInput.click()
      },
      upload() {
        this.uploading = true
        this.$api
          .uploadImage({ image: { prompt: this.$props.prompt, base64_url: this.canvas.backgroundImage.toDataURL() }})
          .then((image : any) => {
            this.$emit('image-uploaded', { src: image.url })
            this.uploading = false
          })
          .catch((error) => {
            console.error(error)
            this.uploading = false
          })
      },
      edit() {

      },
      upscale() {
        // this.upscaling = true

        // this.$api
        //   .post(`/images/${this.canvas.data.imageId}/upscale`)
        //   .then((data) => {
        //     this.upscaling = false
        //   })
      },
      fitToCanvas() {
        // Needs improvements to not cut the image
        this.$props.canvas.setViewportTransform([1, 0, 0, 1, 0, 0])
      }
    }
  }
</script>
