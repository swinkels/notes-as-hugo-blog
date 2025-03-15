(use-modules (gnu packages)
             (gnu packages python)
             (guix download)
             (guix packages))

(define-public python-3.10.12
  (package
   (inherit python-3.10)
   (version "3.10.12")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://www.python.org/ftp/python/"
                                version "/Python-" version ".tar.xz"))
            (patches (search-patches
                      "python-3-arm-alignment.patch"
                      "python-3-deterministic-build-info.patch"
                      "python-3-fix-tests.patch"
                      "python-3-hurd-configure.patch"
                      "python-3-search-paths.patch"))
            (sha256
             (base32
              "1f1hb23gnv2l427bdsl1g59f092gg1g8yb1i21ys9rrhj7qlpdxg"))
            (modules '((guix build utils)))
            (snippet
             '(begin
                ;; Delete the bundled copy of libexpat.
                (delete-file-recursively "Modules/expat")
                (substitute* "Modules/Setup"
                             ;; Link Expat instead of embedding the bundled one.
                             (("^#pyexpat.*") "pyexpat pyexpat.c -lexpat\n"))
                ;; Delete windows binaries
                (for-each delete-file
                          (find-files "Lib/distutils/command" "\\.exe$"))))))))


python-3.10.12
