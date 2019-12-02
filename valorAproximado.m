palabra = imagen_10(:,8);
palabra =char(palabra);
palabra =string(palabra);
disp(palabra);

NET.addAssembly('System.Speech');
obj = System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume = 100;
Speak(obj, palabra);
