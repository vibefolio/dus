import { View, Text, TextInput, Pressable, KeyboardAvoidingView, Platform } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { router } from "expo-router";
import { useState } from "react";
import { Ionicons } from "@expo/vector-icons";

/* 카드 shadow */
const cardShadow = {
  shadowColor: "#000",
  shadowOffset: { width: 0, height: 2 },
  shadowOpacity: 0.06,
  shadowRadius: 12,
  elevation: 3,
};

export default function LoginScreen() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = () => {
    // TODO: API 연동
  };

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        className="flex-1 px-5 justify-center"
      >
        {/* 로고 영역 */}
        <View className="items-center mb-10">
          <View className="w-16 h-16 bg-primary rounded-2xl items-center justify-center mb-4" style={cardShadow}>
            <Ionicons name="brush" size={32} color="#FFFFFF" />
          </View>
          <Text className="text-2xl font-bold tracking-tight text-gray-900">
            DUS
          </Text>
          <Text className="text-body text-gray-400 mt-1">
            디자인 템플릿 마켓플레이스
          </Text>
        </View>

        {/* 입력 폼 카드 */}
        <View className="sn-card mb-6" style={cardShadow}>
          {/* 이메일 */}
          <View className="mb-4">
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
              EMAIL
            </Text>
            <TextInput
              className="sn-input"
              placeholder="이메일을 입력하세요"
              placeholderTextColor="#D1D5DB"
              keyboardType="email-address"
              autoCapitalize="none"
              value={email}
              onChangeText={setEmail}
            />
          </View>

          {/* 비밀번호 */}
          <View>
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
              PASSWORD
            </Text>
            <TextInput
              className="sn-input"
              placeholder="비밀번호를 입력하세요"
              placeholderTextColor="#D1D5DB"
              secureTextEntry
              value={password}
              onChangeText={setPassword}
            />
          </View>
        </View>

        {/* 로그인 버튼 */}
        <Pressable className="sn-btn-primary mb-4" style={cardShadow} onPress={handleLogin}>
          <Text className="sn-btn-primary-text">로그인</Text>
        </Pressable>

        {/* 하단 링크 */}
        <View className="flex-row justify-center gap-4">
          <Pressable>
            <Text className="text-body text-gray-500">회원가입</Text>
          </Pressable>
          <Text className="text-body text-gray-300">|</Text>
          <Pressable>
            <Text className="text-body text-gray-500">비밀번호 찾기</Text>
          </Pressable>
        </View>

        {/* 닫기 */}
        <Pressable
          className="mt-10 items-center"
          onPress={() => router.back()}
        >
          <Text className="text-body text-gray-400">닫기</Text>
        </Pressable>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
