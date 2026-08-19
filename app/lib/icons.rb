# 3D 아이콘 매니페스트 (config/icons.yml) 로더.
#
# 아이콘 파일의 원본은 app/assets/images/icons/ 이고,
# "이름 → 파일 + 한글 라벨" 의 단일 출처가 config/icons.yml 이다.
# 카테고리 한글 라벨도 여기에만 둔다 — admin 폼과 공개 필터가 같은 것을 읽는다.
class Icons
  MANIFEST_PATH = Rails.root.join("config/icons.yml")

  class MissingIcon < StandardError; end

  class << self
    # 이름으로 아이콘 조회. 없으면 nil.
    def lookup(name)
      manifest["icons"][name.to_s]
    end

    # DesignTemplate.category 키 → { "icon" => …, "label" => … }
    def category(key)
      manifest["categories"][key.to_s]
    end

    # 카테고리 전체 (등록 순서 유지)
    def categories
      manifest["categories"]
    end

    # [[한글라벨, 키], …] — select 옵션용
    def category_options
      categories.map { |key, entry| [ entry["label"], key ] }
    end

    def category_label(key)
      category(key)&.dig("label") || key.to_s
    end

    def manifest
      mtime = File.mtime(MANIFEST_PATH)
      return @manifest if @manifest && @mtime == mtime

      @mtime = mtime
      @manifest = YAML.load_file(MANIFEST_PATH).tap do |data|
        data["icons"] ||= {}
        data["categories"] ||= {}
      end
    end

    # 매니페스트에 적힌 파일이 실제로 있는지 검사. 검증 태스크에서 쓴다.
    def missing_files
      root = Rails.root.join("app/assets/images/icons")
      files = manifest["icons"].map { |name, e| [ name, e["file"] ] } +
              manifest["categories"].map { |key, e| [ "category:#{key}", e["icon"] ] }
      files.reject { |_, file| File.exist?(root.join(file.to_s)) }
    end
  end
end
