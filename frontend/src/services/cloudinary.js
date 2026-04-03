const CLOUD_NAME = import.meta.env.PUBLIC_CLOUDINARY_CLOUD_NAME;

export function getCloudinaryUrl(publicId, options = {}) {
  const {
    width = 400, height = 400, crop = 'fill',
    quality = 'auto', format = 'auto', gravity = 'auto',
  } = options;

  const transforms = `w_${width},h_${height},c_${crop},g_${gravity},q_${quality},f_${format}`;

  return `https://res.cloudinary.com/${CLOUD_NAME}/image/upload/${transforms}/${publicId}`;
}

export function getThumbnailUrl(publicId) {
  return getCloudinaryUrl(publicId, { width: 400, height: 400, crop: 'fill' });
}

export function getFullUrl(publicId) {
  return getCloudinaryUrl(publicId, { width: 1200, height: 800, crop: 'fill' });
}