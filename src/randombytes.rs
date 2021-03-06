//! Cryptographic random number generation.

use ffi;
#[cfg(not(feature = "std"))]
use prelude::*;

/// `randombytes()` randomly generates size bytes of data.
pub fn randombytes(size: usize) -> Vec<u8> {
    unsafe {
        let mut buf = vec![0u8; size];
        ffi::randombytes_buf(buf.as_mut_ptr() as *mut _, size);
        buf
    }
}

/// `randombytes_into()` fills a buffer `buf` with random data.
pub fn randombytes_into(buf: &mut [u8]) {
    unsafe {
        ffi::randombytes_buf(buf.as_mut_ptr() as *mut _, buf.len());
    }
}

/// `randombytes_uniform()` returns an unpredictable value between 0 and
/// `upper_bound` (excluded). It guarantees a uniform distribution of the
/// possible output values even when `upper_bound` is not a power of 2. Note
/// that an `upper_bound` < 2 leaves only a  single element to be chosen, namely
/// 0.
pub fn randombytes_uniform(upper_bound: u32) -> u32 {
    unsafe { ffi::randombytes_uniform(upper_bound) }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_randombytes_uniform_0() {
        assert_eq!(randombytes_uniform(0), 0);
    }

    #[test]
    fn test_randombytes_uniform_1() {
        assert_eq!(randombytes_uniform(1), 0);
    }

    #[test]
    fn test_randombytes_uniform_7() {
        assert!(randombytes_uniform(7) < 7);
    }
}
