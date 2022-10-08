class TextPublishForm {
  static get title => "Completa la información";
  static get caption => "Completa los siguientes datos para poder enviar tu colección a revisión.\nUna vez revisada la calección se publicará automáticamente.";
  static get label1 => "Nombre de la colección";
  static get hint1 => "Nombre de la colección";
  static get label2 => "Descripción";
  static get hint2 => "Describe tu colección";
  static get label3 => "Nombre del autor";
  static get hint3 => "Nombre del autor";
  static get label4 => "Email del autor";
  static get hint4 => "Email del autor";
  static get btnPublish => "Publicar colección";
  static get btnCancel => "Descartar colección";
  static get btnBack => "Volver a editar";
  static get titleBanner => "Banner de colección";
  static get captionBanner => "Esta imagen aparecerá en el banner cuando tu colección esté publicada.";
  static get caption2Banner => "Sube o arrastra archivos .PNG";
}

class TextDialogDeleteLayer {
  static get title => "¿Quieres eliminar la capa?";
  static get caption => "Al eliminar esta capa se eliminarán todos los archivos que tengas en ella";
  static get btnCancel => "Cancelar";
  static get btnConfirm => "Eliminar";
}

class TextDialogGenerateCollection {
  static get title => "¿Quieres generar tu colección?";
  static get caption => "Podrás volver a editar tu colección luego de generarla.";
  static get btnCancel => "Cancelar";
  static get btnConfirm => "Generar";
}

class TextDialogDiscardCollection {
  static get title => "¿Quieres eliminar toda la colección?";
  static get caption => "Al eliminar la colección completa no se guardará ningún \ncambio y descartarás todas las combinaciones generadas";
  static get btnCancel => "Cancelar";
  static get btnConfirm => "Eliminar";
}